//
// Created by 杨至轩 on 4/26/17.
//

#include "dsa/DSGraph.h"
#include "flowuni/MemSSA.h"
#include "flowuni/LocalFCP.h"
#include "flowuni/BuFCP.h"
#include <vector>
#include <map>
#include <llvm/IR/InstIterator.h>

using namespace llvm;


namespace{
  static RegisterPass<BuFCP> X("flowuni-bu", "Flow-sensitive unification based points-to analysis", true, true);
}

char BuFCP::ID = 0;

BuFCP::BuFCP() : ModulePass(ID) {

}

void BuFCP::getAnalysisUsage(AnalysisUsage &AU) const {
  // FIXME: it does not preserve LocalMemSSA
  AU.setPreservesAll();
  AU.addRequired<LocalMemSSAWrapper>();
  AU.addRequired<EquivBUDataStructures>();
}

void BuFCP::clear() {
  funcSccNum.clear();
  sccMember.clear();
  sccFCP.clear();
  retInstOfFunc.clear();
  fakeValueToReal.clear();
  sccCount = 1;  // SCC #0 is left as empty for debugging.
  sccFCP.push_back(LocalFCP());
  sccMember.push_back(std::unordered_set<Function*>());
}

bool BuFCP::runOnModule(Module &M) {
  clear();

  buDSA = &getAnalysis<EquivBUDataStructures>();
  buDSA->print(errs(), &M);

  memSSA = &getAnalysis<LocalMemSSAWrapper>();

  // Step1. Extract SCC information from Buttom-up DSA.
  // Functions in the same DSGraph forms a SCC.
  for(Function& F : M) {
    if(funcSccNum.count(&F) > 0 || buDSA->hasDSGraph(F) == false) {
      continue;
    }

    DSGraph* dsg = buDSA->getDSGraph(F);

    sccMember.push_back(std::unordered_set<Function*>());
    for(auto kv : dsg->getReturnNodes()) {
      errs() << kv.first->getName() << ";";
      funcSccNum[const_cast<Function*>(kv.first)] = sccCount;   // I promise not to modify it!
      sccMember[sccCount].insert(const_cast<Function*>(kv.first));

      assert(buDSA->getDSGraph(*kv.first) == dsg && "Assumption 'SCC members share the same DSGraph' is wrong");
    }
    errs() << "\n";
    sccCount += 1;
  }

  // Step2. Build SCC-level CFG and memory SSA.
  for(int i = 0; i < sccCount; i++) {
    auto& scc = sccMember[i];
    for(auto func : scc) {
      resolveInSccCalls(func);
      memSSA->ssa[func].dump();
    }
  }

  // Step3. Perform intra-SCC points-to analysis
  for(int i = 0; i < sccCount; i++) {
    errs() << "\nSCC " << i << "\n";

    sccFCP.push_back(LocalFCP());
    LocalFCP &fcp = sccFCP[i];
    auto &members = sccMember[i];

    errs() << "Member: ";
    for(auto f : members) {
      errs() << f->getName() << ", ";
    }
    errs() << "\n";

    fcp.clear();
    for(auto f : members) {
      fcp.identifyResources(*f);
      fcp.identifyDUGNodes(*f, &memSSA->ssa[f]);
    }
    fcp.identifyDUGEdges();
    resolveSccCallsArgCopy(i, fcp);
    fcp.simplifyDUG();
    for(auto f : members) {
      fcp.initWorkListDomOrder(*f, &memSSA->ssa[f]);
    }
    fcp.chaosIterating();
    fcp.computeDataOut();
    fcp.generateSummary();

    // fcp.checkAssertions();
    if(members.size() > 0) {
      fcp.dump("SccFCP." + (*(members.begin()))->getName().str());
    }
    fcp.countStats();
  }

  errs() << "\n\nBU-stage: \n";

  // Step4. Post-order inline function summary.
  visited = std::vector<bool>(sccCount, false);
  for(int i = 0; i < sccCount; i++) {
    if(!visited[i]) {
      postOrderInline(i);
    }
  }

  for(int i = 0; i < sccCount; i++) {
    errs() << "\nSCC " << i << "\n";
    errs() << "Member: ";
    for(auto f : sccMember[i]) {
      errs() << f->getName() << ", ";
    }
    errs() << "\n";

    sccFCP[i].checkAssertions();
    sccFCP[i].countStats();
  }
  return false;
}

void BuFCP::resolveInSccCalls(Function* f) {
  for(auto inst_ite = inst_begin(f); inst_ite != inst_end(f); inst_ite++) {
    if(auto call = dyn_cast<CallInst>(&*inst_ite)) {
      if(Function *callee = call->getCalledFunction()) {
        if(funcSccNum.count(callee) > 0 && funcSccNum[callee] == funcSccNum[f]) {
          // Direct call to another function in the same SCC. Splice their memSSA together.
          assert(buDSA->hasDSGraph(*f));
          DSGraph *dsg = buDSA->getDSGraph(*f);
          assert(dsg == buDSA->getDSGraph(*callee) && "Functions in the same SCC should have the same DSGraph");

          LocalMemSSA& callerSSA = memSSA->ssa[f];
          LocalMemSSA& calleeSSA = memSSA->ssa[callee];

          if(callerSSA.callArgLastDef.count(call) > 0) {
            auto& actuals = callerSSA.callArgLastDef[call];
            auto& formals = calleeSSA.argIncomingMergePoint;

            // Connects actual arguments ('lastDef') and formal arguments ('argIncomingMergePoint').
            for(const auto& n_i : actuals) {
              DSNode *n = n_i.first;
              if(formals.count(n) > 0) {
                callerSSA.memSSAUsers[n_i.second].insert(formals[n]);
                calleeSSA.memSSADefs[formals[n]].insert(n_i.second);
              }
            }

            // Connects from callee back to the caller.
            auto& callsiteRet = callerSSA.callRetMemMergePoints[call];
            auto& output = calleeSSA.retMemLastDef;
            for(const auto& n_i : callsiteRet) {
              DSNode *n = n_i.first;
              if(output.count(n) > 0) {
                calleeSSA.memSSAUsers[output[n]].insert(n_i.second);
                callerSSA.memSSADefs[n_i.second].insert(output[n]);
              }
            }
          }
        }
      } else if(const Value *callee = call->getCalledValue()) {
        // Indirect call
        assert(0 && "NOT IMPLEMENTED YET");
      }
    } else if(auto ret = dyn_cast<ReturnInst>(&*inst_ite)) {
      retInstOfFunc[f].insert(ret);
    }
  }
}

void BuFCP::resolveSccCallsArgCopy(int scc, LocalFCP & fcp) {
  for(auto f : sccMember[scc]) {
    for(auto inst_ite = inst_begin(f); inst_ite != inst_end(f); inst_ite++) {
      if (auto call = dyn_cast<CallInst>(&*inst_ite)) {
        if(Function *callee = call->getCalledFunction()) {
          if(funcSccNum.count(callee) > 0 && funcSccNum[callee] == funcSccNum[f]) {
            assert(call->getNumArgOperands() == callee->getArgumentList().size()
                   && "caller and callee don't agree with num of arguments");

            // Connects actual arguments to the PHINodes of formal arguments.
            int i = 0;
            for(auto& formal_ref : callee->args()) {
              Value *actual = call->getArgOperand(i);
              Value *formal = &formal_ref;

              if(fcp.argSetInst.count(formal) > 0) {

                Instruction *copyInst = fcp.argSetInst[formal];
                fcp.incomingOfArgOrRet[copyInst].insert(actual);

                Instruction *defInst = nullptr;
                if(Instruction *inst = dyn_cast<Instruction>(actual)) {
                  defInst = inst;
                } else if(fcp.argSetInst.count(actual) > 0) {
                  defInst = fcp.argSetInst[actual];
                }

                if(defInst != nullptr) {
                  fcp.defuseEdges[defInst].insert(copyInst);
                  fcp.usedefEdges[copyInst].insert(defInst);
                }
              }

              i++;
            }

            // Connects returned values of the callee to the CallInst
            assert(retInstOfFunc.count(callee) > 0 && "ReturnInst should be identified in resolveInSccCalls()");
            for(auto ret : retInstOfFunc[callee]) {
              if(auto retVal = ret->getReturnValue()) {
                if(retVal->getType()->isPointerTy()) {
                  fcp.incomingOfArgOrRet[call].insert(retVal);

                  Instruction *defInst = nullptr;
                  if(Instruction *inst = dyn_cast<Instruction>(retVal)) {
                    defInst = inst;
                  } else if(fcp.argSetInst.count(retVal) > 0) {
                    defInst = fcp.argSetInst[retVal];
                  }

                  if(defInst != nullptr) {
                    fcp.defuseEdges[defInst].insert(call);
                    fcp.usedefEdges[call].insert(defInst);
                  }
                }
              }
            }
          }
        } else if(const Value *callee = call->getCalledValue()) {
          // Indirect call
          assert(0 && "NOT IMPLEMENTED YET");
        }
      }
    }
  }
}

void BuFCP::postOrderInline(int scc) {
  visited[scc] = true;

  // Step0. process all dependent SCCs first.

  LocalFCP& myFCP = sccFCP[scc];
  const auto& members = sccMember[scc];

  for(auto f : members) {
    for(auto inst_ite = inst_begin(f); inst_ite != inst_end(f); inst_ite++) {
      if(auto call = dyn_cast<CallInst>(&*inst_ite)) {
        if(auto callee = call->getCalledFunction()) {
          if(funcSccNum.count(callee) > 0 && funcSccNum[callee] != scc
             && not visited[funcSccNum[callee]]) {

            postOrderInline(funcSccNum[callee]);

          }
        } else {
          // Indirect call
          assert(0 && "NOT IMPLEMENTED YET");
        }
      }
    }
  }

  // Now in this SCC, all function calls are one of:
  //   0. calls to a function who has a summary
  //   1. calls to an external function (function declaration)


  // Process calls to external function (function declaration) first.
  // The strategy is simple: treating these calls return an external resource.
  for(auto f : members) {
    for (auto inst_ite = inst_begin(f); inst_ite != inst_end(f); inst_ite++) {
      if (auto call = dyn_cast<CallInst>(&*inst_ite)) {
        if (auto callee = call->getCalledFunction()) {
          if (callee->isDeclaration() && call->getType()->isPointerTy()
              && myFCP.DUGNodes.count(call) > 0) {

            myFCP.externalResources.insert(call);
            myFCP.resources.insert(call);

            myFCP.dataIn[call].valPointTo = call;
            myFCP.dataIn[call].valPointToSets.insert(call);

            for(auto user : myFCP.defuseEdges[call]) {
              if(myFCP.inList.count(user) == 0) {
                myFCP.worklist.push(user);
                myFCP.inList.insert(user);
              }
            }
          }
        }
      }
    }
  }
  if(myFCP.worklist.size() > 0) {
    myFCP.chaosIterating();
  }

  // Now process calls to a function with a summary

  std::vector<CallInst*> callSitesToProcess;

  for(auto f : members) {
    for(auto inst_ite = inst_begin(f); inst_ite != inst_end(f); inst_ite++) {
      if (auto call = dyn_cast<CallInst>(&*inst_ite)) {
        if (auto callee = call->getCalledFunction()) {
          if (callee->isDeclaration()) {
            // assert(0 && "NOT IMPLEMENTED YET");
          } else if (funcSccNum[callee] != scc) {
            assert(funcSccNum.count(callee) > 0 && visited[funcSccNum[callee]]);
            if(myFCP.DUGNodes.count(call) > 0) {
              callSitesToProcess.push_back(call);
            }
          }
        } else {
          assert(0 && "NOT IMPLEMENTED YET");
        }
      }
    }
  }

  while(callSitesToProcess.size() > 0) {

    bool processedOne = false;

    // Find a callsite whose all arguments are calculated, we can inline the callee into this callsite.
    for(int i = 0; i < callSitesToProcess.size(); i++) {
      CallInst *call = callSitesToProcess[i];

      bool argsCalculated = true;
      for(int i = 0; i < call->getNumArgOperands(); i++) {
        Value *actArg = call->getArgOperand(i);
        if(actArg->getType()->isPointerTy() && myFCP.getMemObjectsForVal(actArg) == nullptr) {
          argsCalculated = false;
          break;
        }
      }

      if(argsCalculated) {
        // errs() << "Inlining at " << *call << " of " << call->getParent()->getParent()->getName() << "\n";
        processedOne = true;
        mergeCallsite(call);

        // Re-run chaos-iterating.
        auto& retMemMergePoints = memSSA->ssa[call->getParent()->getParent()].callRetMemMergePoints[call];
        for(const auto& n_phi : retMemMergePoints) {
          for(const auto& user : myFCP.defuseEdges[n_phi.second]) {
            if(myFCP.inList.count(user) == 0) {
              myFCP.worklist.push(user);
              myFCP.inList.insert(user);
            }
          }
        }
        for(const auto& user : myFCP.defuseEdges[call]) {
          if(myFCP.inList.count(user) == 0) {
            myFCP.worklist.push(user);
            myFCP.inList.insert(user);
          }
        }
        myFCP.chaosIterating();

        std::swap(callSitesToProcess[i], callSitesToProcess[callSitesToProcess.size() - 1]);
        callSitesToProcess.pop_back();
      }
    }

    if(not processedOne) {
      assert(false && "All callsites are not processable!");
    }
  }

  myFCP.computeDataOut();
  myFCP.generateSummary();
}

void BuFCP::mergeCallsite(CallInst *call) {
  Function *caller = call->getParent()->getParent();
  assert(caller != nullptr);

  if (auto callee = call->getCalledFunction()) {
    if (callee->isDeclaration()) {
      assert(0 && "NOT IMPLEMENTED YET");
    } else {
      assert(funcSccNum.count(callee) > 0 && visited[funcSccNum[callee]]);
      DSGraph *dsgCaller = buDSA->getDSGraph(*caller);
      DSGraph *dsgCallee = buDSA->getDSGraph(*callee);
      assert(call->getNumArgOperands() == callee->getArgumentList().size());


      // Mapping from Values* in callee to cloned Value* in caller.
      std::unordered_map<Value*, Value*> cloningMapping;
      for(auto& fml : callee->args()) {
        if(fml.getType()->isPointerTy()) {
          cloningMapping[&fml] = PointToGraph::getFreshExternalPlaceholder();
          fakeValueToReal[cloningMapping[&fml]] = &fml;
        }
      }


      UnionFind<DSNode*> alreadyMergedNodes;

      auto& retMemMergePoints = memSSA->ssa[caller].callRetMemMergePoints[call];
      LocalFCP &myFCP = sccFCP[funcSccNum[caller]];

      myFCP.dataOutDelta[call].clear();
      for(auto n_phi : retMemMergePoints) {
        myFCP.dataOutDelta[n_phi.second].clear();
      }

      // For two values in callsite ('a') and callee ('b'), merge their corresponding PointToGraph.
      auto mergeValues = [&](Value* a, Value *b) {
        if(dsgCaller->hasNodeForValue(a) && dsgCallee->hasNodeForValue(b)) {
          DSNodeHandle actNodeH = dsgCaller->getNodeForValue(a);
          DSNodeHandle fmlNodeH = dsgCallee->getNodeForValue(b);

          if (not alreadyMergedNodes.equivalent(actNodeH.getNode(), fmlNodeH.getNode())) {
            mergePointToGraphByDSNodes(actNodeH, fmlNodeH, caller, call, callee, alreadyMergedNodes, cloningMapping);
          }

        }
      };

      // Merge corresponding actual-formal arguments.
      int i = 0;
      for(auto formal_ite = callee->arg_begin(); formal_ite != callee->arg_end();
          formal_ite++, i++) {

        Value *actual = call->getArgOperand(i);
        Value *formal = &*formal_ite;

        if(dsgCaller->hasNodeForValue(actual) && dsgCallee->hasNodeForValue(formal)) {
          DSNodeHandle actNodeH = dsgCaller->getNodeForValue(actual);
          DSNodeHandle fmlNodeH = dsgCallee->getNodeForValue(formal);

          if (not alreadyMergedNodes.equivalent(actNodeH.getNode(), fmlNodeH.getNode())) {
            mergePointToGraphByDSNodes(actNodeH, fmlNodeH, caller, call, callee, alreadyMergedNodes, cloningMapping);
          }

          // Merge formal and actual.
          DSNode *actNode = actNodeH.getNode()->isGlobalNode() ? LocalMemSSA::GlobalsLeader : actNodeH.getNode();
          PHINode *retMergePhi = retMemMergePoints[actNode];
          assert(retMergePhi && "callsite should create a merge point for 'n' at buildSSARenaming() : MemSSA.cpp");

          Value *actMem = myFCP.getMemObjectsForVal(actual);
          Value *fmlMem = cloningMapping[formal];

          bool activated = myFCP.dataIn[retMergePhi].mergeRec(actMem, fmlMem);
          if(activated) {
            myFCP.dataOutDelta[retMergePhi].push_back(make_merge(actMem, fmlMem));
          }
        }
      }

      // Do it for return value.
      for(auto retInst : retInstOfFunc[callee]) {
        if(retInst->getReturnValue()) {
          Value *callerRetValue = call;
          Value *calleeRetValue = retInst->getReturnValue();

          // Clone the memory object pointed by the return value.
          mergeValues(callerRetValue, calleeRetValue);

          if(dsgCaller->hasNodeForValue(callerRetValue) && dsgCallee->hasNodeForValue(calleeRetValue)) {
            DSNodeHandle actNodeH = dsgCaller->getNodeForValue(callerRetValue);
            DSNodeHandle fmlNodeH = dsgCallee->getNodeForValue(calleeRetValue);

            if (not alreadyMergedNodes.equivalent(actNodeH.getNode(), fmlNodeH.getNode())) {
              mergePointToGraphByDSNodes(actNodeH, fmlNodeH, caller, call, callee, alreadyMergedNodes, cloningMapping);
            }

            // Copy the return value itself.
            LocalFCP& calleeFCP = sccFCP[funcSccNum[callee]];
            assert(calleeFCP.DUGNodes.count(retInst) > 0);
            auto& calleeRetGraph = calleeFCP.dataIn[retInst];

            if(calleeRetGraph.valPointTo != nullptr) {

              auto& callGraph = myFCP.dataIn[call];

              // assert(cloningMapping.count(calleeRetGraph.valPointTo) > 0 && "Returned memory should be cloned into the caller");
              clonePointToGraphInto(callGraph, calleeRetGraph, cloningMapping, myFCP.dataOutDelta[call]);

              Value *returnedPtr = cloneValue(calleeRetGraph.valPointTo, cloningMapping);

              if(callGraph.valPointTo == nullptr) {
                callGraph.valPointTo = returnedPtr;
                // errs() << "For " << *call << ", retval is " << PointToGraph::escape(returnedPtr) << " cloned From "
                //        << PointToGraph::escape(calleeRetGraph.valPointTo) << "\n";
              } else {
                bool activated = callGraph.mergeRec(returnedPtr, callGraph.valPointTo);
                errs() << "For " << *call << ", retval merges with " << PointToGraph::escape(returnedPtr) << " cloned From "
                       << PointToGraph::escape(calleeRetGraph.valPointTo) << "\n";
                if(activated) {
                  myFCP.dataOutDelta[call].push_back(make_merge(returnedPtr, callGraph.valPointTo));
                }
              }
            }
          }
        }
      }
    }
  } else {
    // Indirect call
    assert(0 && "NOT IMPLEMENTED YET");
  }

}

// For a CallInst ('callsite') in 'caller' to 'callee', merge the PointToGraph of
// the 'last-definition' of 'm' in 'callee', into the PointToGraph of 'RetArgsMergePoints'
// of 'callsite' for 'n'.
// And recursively merge outgoing links of 'n' and 'm'

void BuFCP::mergePointToGraphByDSNodes(DSNodeHandle nh, DSNodeHandle mh, Function *caller, CallInst *callsite,
                                       Function *callee, UnionFind<DSNode *> &mergedNodes, std::unordered_map<Value*, Value*>& cloningMapping) {

  DSNode *n = nh.getNode();
  DSNode *m = mh.getNode();

  // 'mergedNodes' remembers which DSNodes are already merged in the recursive process.
  mergedNodes.merge(n, m);

  // Find corresponding partial PointToGraphs for 'n' and 'm'
  PHINode *retMergePhi = memSSA->ssa[caller].callRetMemMergePoints[callsite][n->isGlobalNode() ? LocalMemSSA::GlobalsLeader : n];
  assert(retMergePhi && "callsite should create a merge point for 'n' at buildSSARenaming() : MemSSA.cpp");

  Instruction *lastDefInst = memSSA->ssa[callee].retMemLastDef[m->isGlobalNode() ? LocalMemSSA::GlobalsLeader : m];
  assert(lastDefInst && "callee should record last definition instruction for 'm' at buildSSARenaming() : MemSSA.cpp");

  LocalFCP &callerFCP = sccFCP[funcSccNum[caller]];
  LocalFCP &calleeFCP = sccFCP[funcSccNum[callee]];

  assert(callerFCP.DUGNodes.count(retMergePhi) > 0);
  assert(calleeFCP.DUGNodes.count(lastDefInst) > 0);

  // Copy the PointToGraph of 'lastDefInst' into the PointToGraph of 'retMergePhi'.
  PointToGraph &phiGraph = callerFCP.dataIn[retMergePhi];

  auto ite = calleeFCP.dataIn.find(lastDefInst);
  assert(ite != calleeFCP.dataIn.end() && "last definition should have a point to graph");

  PointToGraph &lastDefGraph = ite->second;

  // (NAIVELY) copy it!
  clonePointToGraphInto(phiGraph, lastDefGraph, cloningMapping, callerFCP.dataOutDelta[retMergePhi]);

  // Recursively merge outgoing linked DSNodes for 'n' and 'm'.
  for(auto edge_ite = m->edge_begin(); edge_ite != m->edge_end(); edge_ite++) {
    if(edge_ite->second.getNode()) {
      int off = edge_ite->first - mh.getOffset() + nh.getOffset() ;
      off = off % ((int)nh.getNode()->getSize());
      if(off < 0) {
        off += nh.getNode()->getSize();
      }

      DSNodeHandle nOutH = nh.getLink(off);

      assert(not nOutH.isNull() && "There should be a link. Your calculation is wrong?");

      if(not mergedNodes.equivalent(nOutH.getNode(), edge_ite->second.getNode())) {
        mergePointToGraphByDSNodes(nOutH, edge_ite->second, caller, callsite, callee, mergedNodes, cloningMapping);
      }
    }
  }
}

Value* BuFCP::cloneValue(Value *k, std::unordered_map<Value *, Value *> &cloned) {
  if(k == nullptr) {
    return (Value*)nullptr;
  } else if(k == PointToGraph::unspecificSpace) {
    return k;
  } else if(not PointToGraph::isFakeValue(k) && dyn_cast<GlobalVariable>(k)) {
    return k;
  } else {
    Value *clonedK;
    if(cloned.count(k) == 0) {
      clonedK = PointToGraph::getFreshExternalPlaceholder();
      if(fakeValueToReal.count(k) > 0) {
        fakeValueToReal[clonedK] = fakeValueToReal[k];
      } else {
        fakeValueToReal[clonedK] = k;
      }
      cloned[k] = clonedK;
    } else {
      clonedK = cloned[k];
    }
    return clonedK;
  }
}

// Brute-force-ly clone every thing of 'src' into 'dest'.
// For any Value in 'src', a new 'fake' Value cloning is used in 'dest'.
// The correspondence between real Value* and fake Value* is recorded in 'fakeValueToReal'.

void BuFCP::clonePointToGraphInto(PointToGraph &dest, PointToGraph &src,
                                  std::unordered_map<Value *, Value *> &cloned,
                                  std::vector<DeltaPointToGraph> &destDelta) {

  for(auto kv : src.eqClass.leader) {
    Value *clonedK, *clonedV;

    clonedK = cloneValue(kv.first, cloned);
    clonedV = cloneValue(kv.second, cloned);

    if(not dest.eqClass.equivalent(clonedK, clonedV)) {
      bool activated = dest.mergeRec(clonedK, clonedV);
      if(activated) {
        destDelta.push_back(make_merge(clonedK, clonedV));
      }
    }
  }

  for(auto kv : src.pointTo) {
    if(src.eqClass.find(kv.first) == kv.first) {
      Value *clonedK, *clonedV;

      clonedK = cloneValue(kv.first, cloned);
      clonedV = cloneValue(kv.second, cloned);

      Value *clonedKTo = dest.getPointTo(clonedK);

      if(clonedKTo == nullptr || not dest.eqClass.equivalent(clonedV, clonedKTo)) {
        if(clonedKTo == nullptr) {
          dest.setPointTo(clonedK, clonedV);
        } else {
          dest.mergeRec(clonedKTo, clonedV);
        }
        destDelta.push_back(make_pointTo(clonedK, clonedV));
      }
    }
  }
}