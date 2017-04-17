//
// Created by 杨至轩 on 4/3/17.
//

#include "flowuni/LocalFCP.h"
#include "flowuni/MemSSA.h"
#include "llvm/IR/InstIterator.h"
#include <unordered_set>

using namespace llvm;

namespace{
  static RegisterPass<LocalFCP> X("flowuni", "Flow-sensitive unification based points-to anlaysis", false, false);

  std::string escape(Value* v) {
    std::string str;
    llvm::raw_string_ostream rso(str);
    if(v > (Value*)1024) {
      v->print(rso);
    } else {
      rso<<v;
    }
    return str;
  }
}


char LocalFCP::ID = 0;

LocalFCP::LocalFCP() : FunctionPass(ID) {

}

void LocalFCP::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AU.addRequired<LocalMemSSA>();
}

void LocalFCP::clear() {
  dataIn.clear();
  dataOut.clear();
  DUGNodes.clear();
  defuseEdges.clear();
  usedefEdges.clear();
  while(!worklist.empty()) {
    worklist.pop();
  }
  inList.clear();
  dataOutDelta.clear();
  dataOutInDiff.clear();
  resources.clear();
  memSSA = nullptr;
}

bool LocalFCP::runOnFunction(Function &F) {
  clear();
  memSSA = &getAnalysis<LocalMemSSA>();
  func = &F;
  resources = memSSA->resources;

  // An instruction is considered interesting if it returns an 'interesting' pointer-pointer
  // or it uses an 'interesting' pointer-pointer.
  for(inst_iterator I = inst_begin(F); I != inst_end(F); I++) {
    if(resources.count(&*I)) {
      DUGNodes.insert(&*I);
    } else {
      for (auto op = I->value_op_begin(); op != I->value_op_end(); op++) {
        if(op->getType()->isPointerTy()) {
          DUGNodes.insert(&*I);
          break;
        }
      }
    }
  }

  // Fake PhiNodes are also DUGNodes
  for(const auto& kv : memSSA->phiNodes) {
    for(const auto& kv2: kv.second) {
      DUGNodes.insert(kv2.second);
    }
  }

  // We don't care about storing/loading a non-pointer value. Remove these instructions.
  for(auto ite = DUGNodes.begin(); ite != DUGNodes.end(); ) {
    bool removed = false;
    if(auto store = dyn_cast<StoreInst>(*ite)) {
      if(store->getValueOperand()->getType()->isPointerTy() == false) {
        ite = DUGNodes.erase(ite);
        removed = true;
      }
    } else if(auto load = dyn_cast<LoadInst>(*ite)) {
      if(load->getType()->isPointerTy() == false) {
        ite = DUGNodes.erase(ite);
        removed = true;
      }
    }
    if(!removed) {
      ++ite;
    }
  }

  // Edges between DUGNodes consist of original def-use edges in the LLVM IR and
  // def-use edges in the Memory SSA.
  for(auto inst : DUGNodes) {
    for(auto user : inst->users()) {
      if(auto user_inst = dyn_cast<Instruction>(user)) {
        if(DUGNodes.count(user_inst) > 0) {
          defuseEdges[inst].insert(user_inst);
          usedefEdges[user_inst].insert(inst);
        }
      }
    }
    if(memSSA->memSSAUsers.count(inst) > 0) {
      for(auto user_inst : memSSA->memSSAUsers[inst]) {
        if(DUGNodes.count(user_inst) > 0) {
          defuseEdges[inst].insert(user_inst);
          usedefEdges[user_inst].insert(inst);
        }
      }
    }
  }

  for(auto inst : DUGNodes) {
    worklist.push(inst);
    inList.insert(inst);
  }

#define __DBGFCP
#ifdef __DBGFCP
  for(auto inst : DUGNodes) {
    errs() << "Predecessor of " << *inst << ":\n";
    for(auto def: usedefEdges[inst]) {
      errs() << "\t" << *def << "\n";
    }
  }
#endif

  // TODO: remove redundant DUGNodes, e.g. PhiNodes for non-pointer variables, LLVM debug declaring calls.

  // TODO: initialize global variable/argument variable in PointGraphs.

  while(!worklist.empty()) {
    Instruction *inst = worklist.front();
    assert(DUGNodes.count(inst) > 0);
    worklist.pop();
    inList.erase(inst);

    // The input data-flow data.
    auto& in = dataIn[inst];
    auto& outDelta = dataOutDelta[inst];
    auto& inDelta = outDelta;

    outDelta.clear();

    // Update 'dataIn' for 'inst' from all its predecessors.
    for(auto def: usedefEdges[inst]) {
      if(dyn_cast<AllocaInst>(def) && memSSA->memSSADefs[inst].count(def) == 0 ) {
        // If it is only a value reference to an AllocInst, don't apply Alloca's modification to memory.
        // (It could be done in a more elegant way).
        continue;
      }

      for(const auto& delta: dataOutDelta[def]) {
        if(delta.type == DeltaPointToGraph::Type::Merge) {
          bool activated = in.mergeRec(delta.x, delta.y);
          if(activated) {
            inDelta.push_back(delta);
          }
          errs() << "0merge before " << *inst << "( from " << *def << ") for "<< escape(delta.x) << " and " << escape(delta.y) << "\n";
        } else if(delta.type == DeltaPointToGraph::Type::PointTo) {
          Value *xTo = in.getPointTo(delta.x);
          if(xTo == nullptr) {
            in.setPointTo(delta.x, delta.y);
            inDelta.push_back(delta);
            errs() << "0set pointTo before " << *inst << "( from " << *def << ") for "<< escape(delta.x) << " and " << escape(delta.y) << "\n";
          } else {
            bool activated = in.mergeRec(delta.y, xTo);
            if(activated) {
              inDelta.push_back(make_merge(delta.y, xTo));
            }
            errs() << "1merge before " << *inst << "( from " << *def << ") for "<< escape(xTo) << " and " << escape(delta.y) << "\n";
          }
        }
      }
    }

    // Now outDelta = inDelta = all changes made to dataIn[inst] in this round;
    // To calculate the real 'outDelta', we calculate out all changes would be made by
    // applying the transform function (stored in outInDiff[inst]). The real 'outDelta'
    // is:
    // (dataIn for the previous round) + inDelta + outInDiff[inst]
    //    - ((dataIn for the previous round) + (outInDiff[inst] for the previous round))
    // = inDelta + outInDiff[inst] - (outInDiff[inst] for the previous round)

    std::vector<DeltaPointToGraph> outInDiff;
    bool valPtrChanged = false;

    if(auto load = dyn_cast<LoadInst>(inst)) {
      auto ptr = load->getPointerOperand();
      auto ptrMem = getMemObjectsForVal(ptr);   // resource equivalent class pointed by 'ptr'
      auto ptrTo = in.getPointTo(ptrMem);

      if(in.valPointTo == nullptr && ptrTo != nullptr) {
        // First effective load.
        in.valPointTo = ptrTo;
        in.valPointToSets.insert(ptrTo);
        valPtrChanged = true;
      }
      if(in.valPointTo != nullptr) {
        outDelta.clear();
        auto ptrToLeader = in.eqClass.find(in.valPointTo);

        // The following code calculate dataOut for LoadInst by brute force, i.e.,
        // by checking whether EVERY Value* is equivalent with 'in.valPointTo'.
        // This may be tracked in a smarter and economic way.

        if(in.valPointToSets.count(ptrToLeader) == 0) {
          in.valPointToSets.insert(ptrToLeader);
          outDelta.push_back(make_merge(ptrToLeader, in.valPointTo));
        }

        for(auto kv : in.eqClass.leader) {
          if(in.valPointToSets.count(kv.first) == 0 &&
              in.eqClass.equivalent(kv.first, ptrToLeader)) {
            in.valPointToSets.insert(kv.first);
            outDelta.push_back(make_merge(kv.first, ptrToLeader));
          }
        }
      }
    } else if(dyn_cast<StoreInst>(inst) != nullptr || dyn_cast<AllocaInst>(inst) != nullptr) {

      Value *ptrMem = nullptr, *contentMem = nullptr;

      if(auto store = dyn_cast<StoreInst>(inst)) {
        auto ptr = store->getPointerOperand();
        auto content = store->getValueOperand();
        ptrMem = getMemObjectsForVal(ptr);
        contentMem = getMemObjectsForVal(content);
      } else if(auto alloca = dyn_cast<AllocaInst>(inst)){
        // AllocaInst is treated as storing an 'unspecified' value into the the memory.
        if(in.valPointTo == nullptr) {
          in.valPointTo = alloca;
          in.valPointToSets.insert(alloca);
          valPtrChanged = true;
        }
        ptrMem = alloca;
        contentMem = PointToGraph::unspecificSpace;
      }

      if(ptrMem && contentMem) {
        if(in.eqClass.getRank(ptrMem) == 0) {
          // ptrMem is a singleton equivalent class. Perform strong update.

          // bool removed = false;
          // Overwrite all previous 'pointTo' modification of this memory object.
          for(auto ite = outDelta.begin(); ite != outDelta.end(); ) {
            auto inDel = *ite;
            if(inDel.type == DeltaPointToGraph::Type::PointTo && in.eqClass.equivalent(inDel.x, ptrMem)) {
              ite = outDelta.erase(ite);
          //    removed = true;
            } else {
              ++ite;
            }
          }

          auto delta = make_pointTo(ptrMem, contentMem);
          if(!isEmitted(delta, inst)) {
            outDelta.push_back(delta);
            outInDiff.push_back(delta);
            errs() << "strong update for: " << *ptrMem << ", at " << *inst << ", " << escape(ptrMem) << " to " << escape(contentMem) << "\n";
          }
        } else {
          // ptrMem is not a unique memory resource. Perform weak update.

          auto ptrTo = in.getPointTo(ptrMem);
          if(ptrTo == nullptr) {
            auto delta = make_pointTo(ptrMem, contentMem);
            if(!isEmitted(delta, inst)) {
              outDelta.push_back(delta);
              outInDiff.push_back(delta);
            }
          } else {
            if(!in.eqClass.equivalent(ptrTo, contentMem)) {
              auto delta = make_merge(ptrTo, contentMem);
              if(!isEmitted(delta, inst)) {
                outDelta.push_back(delta);
                outInDiff.push_back(delta);
              }
            }
          }
        }
      }
    } else if(auto phi = dyn_cast<PHINode>(inst)) {
      // Nothing needed
    } else {
      // TODO: other instructions
    }

    if(outDelta.size() > 0 || valPtrChanged) {
      for(auto user : defuseEdges[inst]) {
        if(inList.count(user) == 0) {
          worklist.push(user);
          inList.insert(user);
        }
      }
    }

    dataOutInDiff[inst] = outInDiff;
  }

  // Apply dataOutInDiff to dataIn to compute dataOut.
  for(auto inst: DUGNodes) {
    dataOut[inst] = dataIn[inst];
    for(const auto& delta: dataOutInDiff[inst]) {
      if(delta.type == DeltaPointToGraph::Type::Merge) {
        dataOut[inst].mergeRec(delta.x, delta.y);
      } else if(delta.type == DeltaPointToGraph::Type::PointTo) {
        dataOut[inst].setPointTo(delta.x, delta.y);
      }
    }
#if 0
    if(auto store = dyn_cast<StoreInst>(inst)) {
      auto ptrMem = getMemObjectsForVal(store->getValueOperand());
      errs() << "Before: " << *inst << ", " << dataIn[inst].eqClass.getRank(ptrMem) << "\n";
      errs() << "After: " << *inst << ", " << dataOut[inst].eqClass.getRank(ptrMem) << "\n";
    }
    if(auto load = dyn_cast<LoadInst>(inst)) {
      auto ptrMem = getMemObjectsForVal(load->getPointerOperand());
      auto contentMem = dataIn[inst].getPointTo(ptrMem);
      errs() << "Before: " << *inst << ", " << dataIn[inst].eqClass.getRank(contentMem) << "\n";
      errs() << "After: " << *inst << ", " << dataOut[inst].eqClass.getRank(contentMem) << "\n";
    }
#endif
  }

  dump();

  return false;
}

bool LocalFCP::isEmitted(const DeltaPointToGraph &d, Instruction *i) {
  auto& in = dataIn[i];
  for(const auto& emitted : dataOutInDiff[i]) {
    if(emitted.type == d.type) {
      if(in.eqClass.equivalent(emitted.x, d.x) && in.eqClass.equivalent(emitted.y, d.y)) {
        return true;
      }
    }
  }
  return false;
}

// ----------------------------------------------------------------------------
// Tarjan's amortized O(alpha(n)) disjoint-set implementation.
// ----------------------------------------------------------------------------

template<typename T, template<typename ...> class M>
T UnionFind<T, M>::find(T x) {
  if(leader.count(x) == 0 || leader[x] == x) {
    return x;
  } else {
    T fx = find(leader[x]);
    leader[x] = fx;
    return fx;
  }
}

template<typename T, template<typename ...> class M>
bool UnionFind<T, M>::merge(T x, T y) {
  T fx = find(x);
  T fy = find(y);
  if(fx != fy) {
    int rx = getRank(fx);
    int ry = getRank(fy);
    if(rx < ry) {
      leader[fx] = fy;
    } else if(rx > ry) {
      leader[fy] = fx;
    } else {
      leader[fx] = fy;
      rank[fy] = ry + 1;
    }
    return true;
  } else {
    return false;
  }
}

template<typename T, template<typename ...> class M>
int UnionFind<T, M>::getRank(T x) {
  T fx = find(x);
  if(rank.count(fx) == 0) {
    return 0;
  } else {
    return rank[fx];
  }
}

template<typename T, template<typename ...> class M>
bool UnionFind<T, M>::equivalent(T x, T y) {
  return find(x) == find(y);
}

PointToGraph::PointToGraph() {
  valPointTo = nullptr;
}

Value* PointToGraph::getPointTo(Value *v) {
  Value *f = eqClass.find(v);
  if(pointTo.count(f) > 0) {
    return pointTo[f];
  } else {
    return nullptr;
  }
}

Value* PointToGraph::setPointTo(Value *v, Value* to) {
  Value *f = eqClass.find(v);
  return pointTo[f] = to;
}

Value* PointToGraph::unspecificSpace = (Value*)1;

DeltaPointToGraph::DeltaPointToGraph(DeltaPointToGraph::Type type, Value *x, Value *y) : type(type), x(x), y(y) { }

DeltaPointToGraph llvm::make_pointTo(Value* x, Value *y) {
  return DeltaPointToGraph(DeltaPointToGraph::Type::PointTo, x, y);
}

DeltaPointToGraph llvm::make_merge(Value* x, Value *y) {
  return DeltaPointToGraph(DeltaPointToGraph::Type::Merge, x, y);
}

Value* LocalFCP::getMemObjectsForVal(Value *x) {
  if(resources.count(x) > 0) {
    return x;
  } else if(auto inst = dyn_cast<Instruction>(x)) {
    if(DUGNodes.count(inst) > 0) {
      return dataIn[inst].valPointTo;
    }
  }
  return nullptr;
}

bool LocalFCP::hasMemObjectsForVal(Value *x) {
  if(resources.count(x) > 0) {
    return true;
  } else if(auto inst = dyn_cast<Instruction>(x)) {
    if(DUGNodes.count(inst) > 0) {
      return dataIn[inst].valPointTo != nullptr;
    }
  }
  return false;
}

bool PointToGraph::mergeRec(Value *x, Value *y) {
  if(x == nullptr || y == nullptr) {
    return false;
  }
  Value *px = getPointTo(x);
  Value *py = getPointTo(y);
  bool activated = eqClass.merge(x, y);
  if(activated) {
    mergeRec(px, py);
    if(px != nullptr) {
      setPointTo(x, px);
    } else if(py != nullptr) {
      setPointTo(x, py);
    }
  }
  return activated;
}