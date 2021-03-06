//
// Created by 杨至轩 on 4/3/17.
//

// #define __DBGFCP

#include "flowuni/LocalFCP.h"
#include "flowuni/MemSSA.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Constants.h"
#include <unordered_set>
#include <cmath>

using namespace llvm;

namespace{
  static RegisterPass<LocalFCPWrapper> X("flowuni-local", "Flow-sensitive unification based points-to analysis", true, true);

  template<typename ... Args>
  std::string string_format( const std::string& format, Args ... args )
  {
    size_t size = snprintf( nullptr, 0, format.c_str(), args ... ) + 1; // Extra space for '\0'
    std::unique_ptr<char[]> buf( new char[ size ] );
    snprintf( buf.get(), size, format.c_str(), args ... );
    return std::string( buf.get(), buf.get() + size - 1 ); // We don't want the '\0' inside
  }
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
      inner.runOnFunction(F, &(localSSA->ssa[&F]));
      localFCP[&F] = inner;
    }
  }
  return false;
}


void LocalFCP::clear() {
  resources.clear();
  dataIn.clear();
  dataOut.clear();
  DUGNodes.clear();
  nodeSSA.clear();
  defuseEdges.clear();
  usedefEdges.clear();
  while(!worklist.empty()) {
    worklist.pop();
  }
  inList.clear();
  dataOutDelta.clear();
  dataOutInDiff.clear();
  implicitArgsPointedBy.clear();
  externalResources.clear();
  summary = PointToGraph();
  argSetInst.clear();
  setInstArg.clear();
  fakePhiSource.clear();
  incomingOfArgOrRet.clear();

  numEdges = numInstDUG = numFakePhiDUG = numMsgPassed = numMsgPassedForGlobals = 0;
  numArgValFakePhi = numSSAFakePhi = numArgMemFakePhi = numCallRetFakePhi = 0;
}

bool LocalFCP::runOnFunction(Function &F, LocalMemSSA *memSSA) {
  errs() << "\nrun LocalFCP on: " << F.getName() << "\n";

  clear();

  identifyResources(F);

  identifyDUGNodes(F, memSSA);

  identifyDUGEdges();

  simplifyDUG();

  initWorkListDomOrder(F, memSSA);

  chaosIterating();

  computeDataOut();

  generateSummary();

  dumpSummary("localSum." + F.getName().str());

  checkAssertions();

  dump("localFCP." + F.getName().str());

  return false;
}

void LocalFCP::identifyResources(Function& F) {

  // Identify all resources (alloc / pointer args / globals) to be analyzed in the local phase.
  for(inst_iterator I = inst_begin(F); I != inst_end(F); I++) {

    if(dyn_cast<AllocaInst>(&*I)) {
      resources.insert(&*I);
    }

    for(auto op = I->value_op_begin(); op != I->value_op_end(); op++) {
      Value *op_reduced = *op;

      // Reduce ConstantExpr to the underlying pointer.
      while(auto cexpr = dyn_cast<ConstantExpr>(op_reduced)) {
        if(cexpr->isGEPWithNoNotionalOverIndexing()) {
          assert(cexpr->getOperand(0)->getType()->isPointerTy()
                 && "In LLVM 3.7 the second operand is the pointer");
          op_reduced = cexpr->getOperand(0);
        } else if(cexpr->isCast()) {
          assert(cexpr->getNumOperands() == 1);
          op_reduced = cexpr->getOperand(0);
        } else {
          errs() << "Unrecognized ConstantExpr: " << *op_reduced << "\n";
          break;
        }
      }

      if(dyn_cast<GlobalVariable>(op_reduced)) {
        resources.insert(op_reduced);
        externalResources.insert(op_reduced);
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

void LocalFCP::identifyDUGNodes(Function &F, LocalMemSSA* memSSA) {
  // An instruction is considered in our data-flow analysis if it returns or uses a pointer.
  // (Exception: 1. ReturnInsts are always considered.
  //             2. CallInsts are always considered
  //             3. Store/Load-Insts of non-pointer Values are not considered
  //             4. CmpInsts are always not considered
  for(inst_iterator I = inst_begin(F); I != inst_end(F); I++) {
    if(resources.count(&*I)) {
      DUGNodes.insert(&*I);
      //   Remembering the 'memSSA' pointer should be safe if 'memSSA' is a pointer to a element
      //   of a unordered_map container (of 'LocalMemSSAWrapper')
      nodeSSA[&*I] = memSSA;
    } else if(dyn_cast<ReturnInst>(&*I) || dyn_cast<CallInst>(&*I)) {
      DUGNodes.insert(&*I);
      nodeSSA[&*I] = memSSA;
    } else if(I->getType()->isPointerTy()) {
      DUGNodes.insert(&*I);
      nodeSSA[&*I] = memSSA;
    } else {
      if(auto store = dyn_cast<StoreInst>(&*I)) {
        if(store->getValueOperand()->getType()->isPointerTy()) {
          DUGNodes.insert(&*I);
          nodeSSA[&*I] = memSSA;
        }
      } else if(auto load = dyn_cast<LoadInst>(&*I)) {
        if(load->getType()->isPointerTy()) {
          DUGNodes.insert(&*I);
          nodeSSA[&*I] = memSSA;
        }
      } else if(dyn_cast<CmpInst>(&*I) == nullptr) {
        for (auto op = I->value_op_begin(); op != I->value_op_end(); op++) {
          if(op->getType()->isPointerTy()) {
            DUGNodes.insert(&*I);
            nodeSSA[&*I] = memSSA;
            break;
          }
        }
      }
    }
  }

  // For pointer-type formal arguments, create a PHINode for it so that it can be merged
  // with actual arguments in the inter-procedural phase.
  for(auto arg_ite = F.arg_begin(); arg_ite != F.arg_end(); arg_ite++) {
    if(arg_ite->getType()->isPointerTy()) {
      Value *arg = &*arg_ite;
      PHINode *phi = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
      argSetInst[arg] = phi;
      setInstArg[phi] = arg;

      DUGNodes.insert(phi);
      nodeSSA[phi] = memSSA;
      numArgValFakePhi += 1;
    }
  }

  // Fake PhiNodes are also DUGNodes
  for(const auto& kv : memSSA->phiNodes) {
    for(const auto& kv2: kv.second) {
      DUGNodes.insert(kv2.second);
      nodeSSA[kv2.second] = memSSA;
      numSSAFakePhi += 1;
      fakePhiSource[kv2.second] = kv2.first;
    }
  }

  for(const auto& kv : memSSA->argIncomingMergePoint) {
    DUGNodes.insert(kv.second);
    nodeSSA[kv.second] = memSSA;
    numArgMemFakePhi += 1;
    fakePhiSource[kv.second] = kv.first;
  }

  for(const auto& kv : memSSA->callRetMemMergePoints) {
    for(const auto& np : kv.second) {
      DUGNodes.insert(np.second);
      nodeSSA[np.second] = memSSA;
      numCallRetFakePhi += 1;
      fakePhiSource[np.second] = np.first;
    }
  }
}


void LocalFCP::identifyDUGEdges() {
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

    if(setInstArg.count(inst) > 0) {
      Value *arg = setInstArg[inst];
      for(auto user : arg->users()) {
        if(auto user_inst = dyn_cast<Instruction>(user)) {
          if(DUGNodes.count(user_inst) > 0) {
            defuseEdges[inst].insert(user_inst);
            usedefEdges[user_inst].insert(inst);
          }
        }
      }
    }

    assert(nodeSSA.count(inst) > 0 && "identifyDUGNodes should remember the correspondence");
    LocalMemSSA *memSSA = nodeSSA[inst];
    if(memSSA->memSSAUsers.count(inst) > 0) {
      for(auto user_inst : memSSA->memSSAUsers[inst]) {
        if(DUGNodes.count(user_inst) > 0) {
          defuseEdges[inst].insert(user_inst);
          usedefEdges[user_inst].insert(inst);
        }
      }
    }
  }

#ifdef __DBGFCP
  for(auto inst : DUGNodes) {
    errs() << "Predecessor of " << *inst << ":\n";
    for(auto def: usedefEdges[inst]) {
      errs() << "\t" << *def << "\n";
    }
  }
#endif
}


void LocalFCP::initWorkListDomOrder(Function &F, LocalMemSSA* memSSA) {
  // Push all DUGNodes to the worklist in an order consistent with the dominance order.
  // (If 'a' dominates 'b', then 'a' precedes 'b' in the initial worklist). This is crucial
  // to guarantee for every instruction in the iteration process, its used Values were
  // calculated at least once.
  for(const auto& kv : memSSA->argIncomingMergePoint) {
    worklist.push(kv.second);
    inList.insert(kv.second);
  }

  for(auto arg_ite = F.arg_begin(); arg_ite != F.arg_end(); arg_ite++) {
    if(argSetInst.count(&*arg_ite)) {
      worklist.push(argSetInst[&*arg_ite]);
      inList.insert(argSetInst[&*arg_ite]);
    }
  }

  std::unordered_set<BasicBlock*> __visitedBB;
  initWorkListDomOrder(memSSA, &F.getEntryBlock(), __visitedBB);
}

void LocalFCP::simplifyDUG() {
  // TODO: remove redundant DUGNodes, for example:
  //   1. PHINodes for non-pointer variables,
  //   2. LLVM debug declaring calls,
  //   3. PHINodes with only one incoming and outgoing edge.
  int removeable = 0;
  for(auto inst : DUGNodes) {
    if(defuseEdges[inst].size() == 0 && usedefEdges[inst].size() == 0) {
      removeable += 1;
    } else if(defuseEdges[inst].size() == 1 && usedefEdges[inst].size() == 1 && dyn_cast<PHINode>(inst)){
      removeable += 1;
    }
  }
  errs() << "Num of removable nodes: " << removeable << "\n";
}

void LocalFCP::chaosIterating() {

  while(!worklist.empty()) {
    Instruction *inst = worklist.front();
    worklist.pop();
    inList.erase(inst);

    assert(DUGNodes.count(inst) > 0);
    // errs() << "chaos-iteration on " << *inst << "\n";

    // The input data-flow data.
    auto& in = dataIn[inst];
    auto& outDelta = dataOutDelta[inst];
    auto& inDelta = outDelta;

    outDelta.clear();

    // Update 'dataIn' for 'inst' from all its predecessors.
    for(auto def: usedefEdges[inst]) {
      if(dyn_cast<AllocaInst>(def) && nodeSSA[inst]->memSSADefs[inst].count(def) == 0 ) {
        // If it is only a value reference to an AllocInst, don't apply Alloca's modification to memory.
        // FIXME: do this in a more elegant way.
        continue;
      }

      for(const auto& delta: dataOutDelta[def]) {
        numMsgPassed += 1;
        if(fakePhiSource.count(inst) > 0 && fakePhiSource[inst] == LocalMemSSA::GlobalsLeader) {
          numMsgPassedForGlobals += 1;
        }
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

      outDelta.clear();
      if(ptrMem != nullptr) {

        if(ptrTo == nullptr) {
          assert(externalResources.count(ptrMem) > 0 && "Non-external memory objects should always points to something");

          ptrTo = getImplicitArgOf(ptrMem);

#ifdef __DBGFCP
          errs() << "get implicit argument at " << *inst << ", for " << PointToGraph::escape(ptrMem) << ", result: " << PointToGraph::escape(ptrTo) << "\n";
#endif

          in.setPointTo(ptrMem, ptrTo);
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

#ifdef __DBGFCP
            errs() << "strong update for: " << PointToGraph::escape(ptrMem) << ", at " << *inst << ", " << " to " << PointToGraph::escape(contentMem) << "\n";
#endif
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
      }
    } else if(auto phi = dyn_cast<PHINode>(inst)) {
      if(setInstArg.count(phi) > 0) {
        // It's a fake PHINode for setting formal argument.
        for(auto ptr : incomingOfArgOrRet[phi]) {
          auto ptrMem = getMemObjectsForVal(ptr);
          if(ptrMem == nullptr) {
            continue;
          }
          assert(setInstArg.count(phi) > 0);
          outDelta.push_back(make_merge(setInstArg[phi], ptrMem));
        }
      } else if(phi->getType()->isPointerTy()){
        // It's a real PHINode for LLVM Values.
        for(auto& ptr : phi->incoming_values()) {
          auto ptrMem = getMemObjectsForVal(ptr.get());
          if(ptrMem == nullptr) {
            continue;
          }
          if(in.valPointTo == nullptr) {
            in.valPointTo = ptrMem;
            valPtrChanged = true;
          } else {
            bool activated = in.mergeRec(in.valPointTo, ptrMem);
            if(activated) {
              inDelta.push_back(make_merge(in.valPointTo, ptrMem));
            }
          }
        }
      } else {
        // It's a fake PHINode for memory objects. NOTHING need to do.
      }
    } else if(auto cast = dyn_cast<BitCastInst>(inst)) {
      if(cast->getSrcTy()->isPointerTy() && cast->getDestTy()->isPointerTy()) {
        // Pointer to pointer cast
        auto src = cast->getOperand(0);
        auto srcMem = getMemObjectsForVal(src);
        if(in.valPointTo == nullptr && srcMem != nullptr) {
          valPtrChanged = true;
          in.valPointTo = srcMem;
          // TODO: maintain valPointToSet in an easy way.
        }
      }
    } else if(auto gep = dyn_cast<GetElementPtrInst>(inst)) {
      // Our implementation is field-insensitive so the GEP instruction is treated as
      // directly returning the pointer operand.
      auto src = gep->getPointerOperand();
      auto srcMem = getMemObjectsForVal(src);
      if(in.valPointTo == nullptr && srcMem != nullptr) {
        valPtrChanged = true;
        in.valPointTo = srcMem;
        // TODO: maintain valPointToSet in an easy way.
      }
    } else if(auto ret = dyn_cast<ReturnInst>(inst)) {
      Value *retPtr = ret->getReturnValue();
      if(retPtr && retPtr->getType()->isPointerTy()) {
        auto retMem = getMemObjectsForVal(retPtr);
        in.valPointTo = retMem;
      }
    } else if (auto call = dyn_cast<CallInst>(inst)) {
      // For intra-SCC calls, merge returned value.
      if(incomingOfArgOrRet.count(call) > 0) {
        for(auto ptr : incomingOfArgOrRet[call]) {
          auto ptrMem = getMemObjectsForVal(ptr);
          if(ptrMem == nullptr) {
            continue;
          }
          if(in.valPointTo == nullptr) {
            in.valPointTo = ptrMem;
            valPtrChanged = true;
          } else {
            outDelta.push_back(make_merge(in.valPointTo, ptrMem));
          }
        }
      }
    } else {
      // TODO: other instructions
      errs() << "Unknown instruction type: " << *inst << "\n";
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
}

void LocalFCP::computeDataOut() {
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

void LocalFCP::countStats() {
  numInstDUG = numFakePhiDUG = numEdges = 0;
  for(auto node : DUGNodes) {
    if(node->getType()->isVoidTy() && dyn_cast<PHINode>(node)) {
      numFakePhiDUG += 1;
    } else {
      numInstDUG += 1;
    }
  }

  for(auto kv : defuseEdges) {
    numEdges += kv.second.size();
  }
  errs() << "Stats: \n";
  errs() << "Number of fake PHINodes: " << numFakePhiDUG << "\n";

  errs() << "\tNumber of ArgVal fake PHI: " << numArgValFakePhi << "\n";
  errs() << "\tNumber of ArgMem fake PHI: " << numArgMemFakePhi << "\n";
  errs() << "\tNumber of MemSSA fake PHI: " << numSSAFakePhi << "\n";
  errs() << "\tNumber of Callsite fake PHI: " << numCallRetFakePhi << "\n";

  errs() << "Number of instruction DUGNodes: " << numInstDUG << "\n";
  int numNodes = numInstDUG + numFakePhiDUG;
  errs() << "Number of DUGNodes in total: |V| = " << numNodes << "\n";
  errs() << "Number of DUGEdges: " << numEdges
         << string_format(" ( = |V|^%.3f )\n", log(numEdges)/log(numNodes) );
  errs() << "Number of messages passed in iterations:" << numMsgPassed
         << string_format(" ( = |V|^%.3f )\n", log(numMsgPassed)/log(numNodes) );
  errs() << "Number of messages passed for globals: " << numMsgPassedForGlobals
         << string_format(" ( %.2f%% of total )\n", (double)(numMsgPassedForGlobals) / numMsgPassed * 100);
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

bool PointToGraph::isFakeValue(Value *v) {
  char *addr = (char*) v;
  return (addr >= externalPlaceholderBase && addr < externalPlaceholderTop);
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
  } else if(auto cexpr = dyn_cast<ConstantExpr>(x)) {
    if(cexpr->isGEPWithNoNotionalOverIndexing()) {
      assert(cexpr->getOperand(0)->getType()->isPointerTy()
             && "In LLVM 3.7 the second operand is the pointer");
      return getMemObjectsForVal(cexpr->getOperand(0));
    } else if(cexpr->isCast()) {
      assert(cexpr->getNumOperands() == 1);
      return getMemObjectsForVal(cexpr->getOperand(0));
    }
  }
  return nullptr;
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
  std::unordered_set<Value*> visited;
  do {
    if(eqClass.getRank(x) == 0) {
      eqClass.rank[eqClass.find(x)] = 1;
    }
    visited.insert(x);
    x = getPointTo(x);
  } while(x != nullptr && visited.count(x) == 0);
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
  } else if(PointToGraph::isFakeValue(v)) {
    rso << "<external " << ((char*)v - (char*)externalPlaceholderBase) << ">";
  } else {
    v->print(rso);
  }
  return str;
}

void LocalFCP::initWorkListDomOrder(LocalMemSSA *memSSA, BasicBlock *bb, std::unordered_set<BasicBlock*>& visited) {
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
    if(auto call = dyn_cast<CallInst>(inst)) {
      if(memSSA->callRetMemMergePoints.count(call) > 0) {
        for(const auto& np : memSSA->callRetMemMergePoints[call]) {
          worklist.push(np.second);
          inList.insert(np.second);
        }
      }
    }
    if(DUGNodes.count(inst) > 0) {
      worklist.push(inst);
      inList.insert(inst);
    }
  }
  for(auto succ: successors(bb)) {
    if(visited.count(succ) == 0) {
      initWorkListDomOrder(memSSA, succ, visited);
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
}