//
// Created by 杨至轩 on 4/3/17.
//

#include "flowuni/LocalFCP.h"
#include "flowuni/MemSSA.h"
#include "llvm/IR/InstIterator.h"
#include <unordered_set>

using namespace llvm;


namespace{
  static RegisterPass<LocalFCPWrapper> X("flowuni-local", "Flow-sensitive unification based points-to analysis", true, true);
}



char LocalFCPWrapper::ID = 0;

LocalFCPWrapper::LocalFCPWrapper() : ModulePass(ID) {

}

void LocalFCPWrapper::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AU.addRequired<LocalMemSSAWrapper>();
}

bool LocalFCPWrapper::runOnModule(Module &M) {
  auto localSSA = &getAnalysis<LocalMemSSAWrapper>();
  for(auto& F : M) {
    if(F.isDeclaration() == false) {
      inner.memSSA = &(localSSA->ssa[&F]);
      inner.func = &F;
      inner.runOnFunction(F);
    }
  }
  return false;
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
  implicitArgsPointedBy.clear();
  externalResources.clear();
  summary = PointToGraph();
}

bool LocalFCP::runOnFunction(Function &F) {
  errs() << "\nrun LocalFCP on: " << F.getName() << "\n";
  clear();

  identifyResources();

  // An instruction is considered interesting if it returns an 'interesting' pointer-pointer
  // or it uses an 'interesting' pointer-pointer.
  for(inst_iterator I = inst_begin(F); I != inst_end(F); I++) {
    if(resources.count(&*I)) {
      DUGNodes.insert(&*I);
    } else if(dyn_cast<ReturnInst>(&*I)) {
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

  // Push all DUGNodes to the worklist in an order consistent with the dominance order.
  // (If 'a' dominates 'b', then 'a' precedes 'b' in the initial worklist). This is crucial
  // to guarantee for every instruction in the iteration process, its used Values were
  // calculated at least once.
  std::unordered_set<BasicBlock*> __visitedBB;
  initWorkListDomOrder(&F.getEntryBlock(), __visitedBB);

 //#define __DBGFCP
#ifdef __DBGFCP
  for(auto inst : DUGNodes) {
    errs() << "Predecessor of " << *inst << ":\n";
    for(auto def: usedefEdges[inst]) {
      errs() << "\t" << *def << "\n";
    }
  }
#endif

  // TODO: remove redundant DUGNodes, e.g. PhiNodes for non-pointer variables, LLVM debug declaring calls.

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
#ifdef __DBGFCP
          errs() << "0merge before " << *inst << "( from " << *def << ") for "<< PointToGraph::escape(delta.x) << " and " << PointToGraph::escape(delta.y) << "\n";
#endif
        } else if(delta.type == DeltaPointToGraph::Type::PointTo) {
          Value *xTo = in.getPointTo(delta.x);
          if(xTo == nullptr) {
            in.setPointTo(delta.x, delta.y);
            inDelta.push_back(delta);
#ifdef __DBGFCP
            errs() << "0set pointTo before " << *inst << "( from " << *def << ") for "<< PointToGraph::escape(delta.x) << " and " << PointToGraph::escape(delta.y) << "\n";
#endif
          } else {
            bool activated = in.mergeRec(delta.y, xTo);
            if(activated) {
              inDelta.push_back(delta);
            }
#ifdef __DBGFCP
            errs() << "1merge before " << *inst << "( from " << *def << ") for "<< PointToGraph::escape(xTo) << " and " << PointToGraph::escape(delta.y) << "\n";
#endif
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

      assert(ptrMem != nullptr);

      outDelta.clear();

      if(ptrTo == nullptr) {
        assert(externalResources.count(ptrMem) > 0 && "Non-external memory objects should always points to something");

        ptrTo = getImplicitArgOf(ptrMem);
#ifdef __DBGFCP
        errs() << "get implicit argument at " << *inst << ", for " << PointToGraph::escape(ptrMem) << ", result: " << PointToGraph::escape(ptrTo) << "\n";
#endif

        in.setPointTo(ptrMem, ptrTo);
        outDelta.push_back(make_pointTo(ptrMem, ptrTo));
        resources.insert(ptrTo);
      }

      if(in.valPointTo == nullptr && ptrTo != nullptr) {
        // First effective load.
        in.valPointTo = ptrTo;
        in.valPointToSets.insert(ptrTo);
        valPtrChanged = true;
      }
      if(in.valPointTo != nullptr) {
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
        if(ptrMem == nullptr || contentMem == nullptr) {
          errs() << "Error at " << *inst << "\n";
          errs() << *ptr << " " << ptrMem << "\n";
          errs() << *content << " " << contentMem << "\n";
        }
        assert(ptrMem && contentMem && "Referenced values should be calculated at least once.");
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

      if(in.eqClass.getRank(ptrMem) == 0 /* && externalResources.count(ptrMem) == 0*/) {
        // ptrMem is a singleton equivalent class. Perform strong update.

        // Overwrite all previous 'pointTo' modification of this memory object.
        for(auto ite = outDelta.begin(); ite != outDelta.end(); ) {
          auto inDel = *ite;
          if(inDel.type == DeltaPointToGraph::Type::PointTo && in.eqClass.equivalent(inDel.x, ptrMem)) {
            ite = outDelta.erase(ite);
          } else {
            ++ite;
          }
        }

        auto delta = make_pointTo(ptrMem, contentMem);
        if(!isEmitted(delta, inst)) {
          outDelta.push_back(delta);
          outInDiff.push_back(delta);
          // errs() << "strong update for: " << *ptrMem << ", at " << *inst << ", " << escape(ptrMem) << " to " << escape(contentMem) << "\n";
        }
      } else {
        // ptrMem is not a unique memory resource. Perform weak update.
        auto ptrTo = in.getPointTo(ptrMem);

        if(ptrTo == nullptr || !in.eqClass.equivalent(ptrTo, contentMem)) {
          if(ptrTo == nullptr) {
            assert(externalResources.count(ptrMem) > 0 && "Non-external memory objects should always points to something");
            auto ptrToNew = getImplicitArgOf(ptrMem);
            errs() << "get implicit argument at " << *inst << ", for " << PointToGraph::escape(ptrMem) << ", result: " << PointToGraph::escape(ptrToNew) << "\n";
            auto delta = make_pointTo(ptrMem, ptrToNew);
            outDelta.push_back(delta);
            outInDiff.push_back(delta);
            resources.insert(ptrToNew);
          }

          auto delta = make_pointTo(ptrMem, contentMem);
          if(!isEmitted(delta, inst)) {
            outDelta.push_back(delta);
            outInDiff.push_back(delta);
          }
        }
      }
    } else if(auto phi = dyn_cast<PHINode>(inst)) {
      // Nothing needed
    } else if(auto cast = dyn_cast<BitCastInst>(inst)) {
      if(cast->getSrcTy()->isPointerTy() && cast->getDestTy()->isPointerTy()) {
        // Pointer to pointer cast
        auto src = cast->getOperand(0);
        auto srcMem = getMemObjectsForVal(src);
        if(in.valPointTo == nullptr) {
          valPtrChanged = true;
          in.valPointTo = srcMem;
          // TODO: maintain valPointToSet in an easy way.
        }
      }
    } else if(auto ret = dyn_cast<ReturnInst>(inst)) {
      Value *retPtr = ret->getReturnValue();
      if(retPtr && retPtr->getType()->isPointerTy()) {
        auto retMem = getMemObjectsForVal(retPtr);
        in.valPointTo = retMem;
      }
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

    // For instructions like 'BitCastInst', its valPointToSets is not maintained in the iteration process.
    // Fix this at this point.
    if(dataIn[inst].valPointTo != nullptr) {
      auto& in = dataIn[inst];
      Value *ptr = in.valPointTo;
      in.valPointToSets.insert(in.eqClass.find(ptr));
      for(auto& kv : in.eqClass.leader) {
        if(in.eqClass.equivalent(kv.first, ptr)) {
          in.valPointToSets.insert(kv.first);
        }
      }
    }

    dataOut[inst] = dataIn[inst];
    for(const auto& delta: dataOutInDiff[inst]) {
      if(delta.type == DeltaPointToGraph::Type::Merge) {
        dataOut[inst].mergeRec(delta.x, delta.y);
      } else if(delta.type == DeltaPointToGraph::Type::PointTo) {
        dataOut[inst].setPointTo(delta.x, delta.y);
      }
    }
  }

  generateSummary();

  checkAssertions();

  dump();

  return false;
}

void LocalFCP::identifyResources() {
  Function &F = *func;
  // Identify all resources (alloc / pointer args / globals) to be analyzed in the local phase.
  for(inst_iterator I = inst_begin(F); I != inst_end(F); I++) {
    if(dyn_cast<AllocaInst>(&*I)) {
      resources.insert(&*I);
    }
#if 0 // pointers returned by functions need not to be processed in the local phase.
    else if(auto ci = dyn_cast<CallInst>(&*I)) {
      if(ci->getType()->isPointerTy()) {
        resources.insert(ci);
      }
    }
#endif
    for(auto op = I->value_op_begin(); op != I->value_op_end(); op++) {
      if(dyn_cast<GlobalVariable>(*op)) {
        resources.insert(*op);
        externalResources.insert(*op);
      }
    }
  }
  for(auto arg_ite = F.arg_begin(); arg_ite != F.arg_end(); arg_ite++) {
    if(arg_ite->getType()->isPointerTy()) {
      resources.insert(&*arg_ite);
      externalResources.insert(&*arg_ite);
    }
  }
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

char* const PointToGraph::externalPlaceholderBase = (char* const)1024;
char* const PointToGraph::externalPlaceholderTop = (char* const)(0x8048000);
char* PointToGraph::externalPlaceholderCurrent = (char*)1024;
Value* PointToGraph::getFreshExternalPlaceholder() {
  Value* ret = (Value*) (externalPlaceholderCurrent++);
  if(externalPlaceholderCurrent >= externalPlaceholderTop) {
    errs() << "Fake pointers address space wrapped!\n";
    externalPlaceholderCurrent = externalPlaceholderBase;
  }
  return ret;
}

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

std::unordered_set<Value*> LocalFCP::getPointToSetForVal(Value *x) {
  std::unordered_set<Value*> s;
  if(resources.count(x) > 0) {
    s.insert(x);
  } else if(auto inst = dyn_cast<Instruction>(x)) {
    if(DUGNodes.count(inst) > 0) {
      s = dataIn[inst].valPointToSets;
    }
  }
  return s;
}


void PointToGraph::mergeUnnamedRec(Value *x) {
  if(eqClass.getRank(x) == 0) {
    eqClass.rank[eqClass.find(x)] = 1;
  }
  Value *to = getPointTo(x);
  if(to != nullptr) {
    mergeUnnamedRec(to);
  }
}

bool PointToGraph::mergeRec(Value *x, Value *y) {
  if(x == nullptr && y == nullptr) {
    return false;
  } else if(x == nullptr) {
    mergeUnnamedRec(y);
    return true;
  } else if(y == nullptr) {
    mergeUnnamedRec(x);
    return true;
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

std::string PointToGraph::escape(Value* v) {
  std::string str;
  llvm::raw_string_ostream rso(str);
  if(v == nullptr) {
    rso << "<nullptr>";
  } else if(v == unspecificSpace) {
    rso << "<unspecific space>";
  } else if((char*)v >= externalPlaceholderBase && (char*)v < externalPlaceholderTop) {
    rso << "<external " << ((char*)v - (char*)externalPlaceholderBase) << ">";
  } else {
    v->print(rso);
  }
  return str;
}

void LocalFCP::initWorkListDomOrder(BasicBlock *bb, std::unordered_set<BasicBlock*>& visited) {
  visited.insert(bb);
  for(auto& n_phi : memSSA->phiNodes[bb]) {
    PHINode *phi = n_phi.second;
    if(DUGNodes.count(phi) > 0) {
      worklist.push(phi);
      inList.insert(phi);
    }
  }
  for(auto& I : *bb) {
    Instruction *inst = &I;
    if(DUGNodes.count(inst) > 0) {
      worklist.push(inst);
      inList.insert(inst);
    }
  }
  for(auto succ: successors(bb)) {
    if(visited.count(succ) == 0) {
      initWorkListDomOrder(succ, visited);
    }
  }
}

Value* LocalFCP::getImplicitArgOf(Value *x) {
  // FIXME: if 'x' is not a single memory object, the returned Value* should also not.
  // However, the following code should be OK if strong update is sacrificed for arguments and globals.
  // If you want to modify the code to support strong update for arguments:
  //   1. Modify the following code to return a merged implicit argument of all implicit argument pointed by
  //      elements of 'x'.
  //   2. Modify mergeRec() for the case of one argument is nullptr.
  if(implicitArgsPointedBy.count(x) == 0) {
    implicitArgsPointedBy[x] = PointToGraph::getFreshExternalPlaceholder();
    externalResources.insert(implicitArgsPointedBy[x]);
  }
  return implicitArgsPointedBy[x];
}

void LocalFCP::generateSummary() {
  // Merge all ReturnInst into a single summary.

  std::vector<Instruction*> retInsts;
  for(auto inst : DUGNodes) {
    if(dyn_cast<ReturnInst>(inst)) {
      retInsts.push_back(inst);
    }
  }

  if(retInsts.size() == 0) {
    return;
  }

  summary = dataOut[retInsts[0]];

  for(int i = 1; i < retInsts.size(); i++) {
    const auto& ptg = dataOut[retInsts[i]];
    for(auto kv : ptg.eqClass.leader) {
      summary.mergeRec(kv.first, kv.second);
    }
    for(auto kv : ptg.pointTo) {
      auto ptrTo = summary.getPointTo(kv.first);
      if(ptrTo == nullptr) {
        summary.setPointTo(kv.first, kv.second);
      } else {
        summary.mergeRec(kv.second, ptrTo);
      }
    }
    summary.mergeRec(summary.valPointTo, ptg.valPointTo);
  }

  dumpSummary();
}