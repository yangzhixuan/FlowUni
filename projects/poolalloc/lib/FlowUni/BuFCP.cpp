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
  sccCount = 0;
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

      assert(buDSA->getDSGraph(*kv.first) == dsg && "Assumption 'SCC members share a DSGraph' is wrong");
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

  // Step3. Perform SCC-local points-to analysis
  for(int i = 0; i < sccCount; i++) {
    sccFCP.push_back(LocalFCP());
    LocalFCP &fcp = sccFCP[i];
    auto &scc = sccMember[i];

    fcp.clear();
    for(auto f : scc) {
      fcp.identifyResources(*f);
      fcp.identifyDUGNodes(*f, &memSSA->ssa[f]);
    }
    fcp.identifyDUGEdges();
    resolveSccCallsArgCopy(i, fcp);
    fcp.simplifyDUG();
    for(auto f : scc) {
      fcp.initWorkListDomOrder(*f, &memSSA->ssa[f]);
    }
    fcp.chaosIterating();
    fcp.computeDataOut();
    fcp.generateSummary();
  }

  // Step4. Post-order inline function summary.
  return false;
}

void BuFCP::resolveInSccCalls(Function* f) {
  for(auto inst_ite = inst_begin(f); inst_ite != inst_end(f); inst_ite++) {
    if(auto call = dyn_cast<CallInst>(&*inst_ite)) {
      if(Function *callee = call->getCalledFunction()) {
        if(funcSccNum.count(callee) > 0 && funcSccNum[callee] == funcSccNum[f]) {
          // Direct call to another function in the same SCC. Splice their memSSA together.
          DSGraph *dsg = buDSA->getDSGraph(*f);
          assert(dsg == buDSA->getDSGraph(*callee) && "Functions in the same SCC should have the same DSGraph");

          LocalMemSSA& callerSSA = memSSA->ssa[f];
          LocalMemSSA& calleeSSA = memSSA->ssa[callee];

          // Look up a const pointer should be safe. Take care not to store the casted pointer in memSSA.
          CallInst *call_mut = const_cast<CallInst*>(call);
          if(callerSSA.callArgLastDef.count(call_mut) > 0) {
            auto& actual = callerSSA.callArgLastDef[call_mut];
            auto& formal = calleeSSA.argIncomingMergePoint;

            // Connects actual arguments ('lastDef') and formal arguments ('argIncomingMergePoint').
            for(const auto& n_i : actual) {
              DSNode *n = n_i.first;
              if(formal.count(n) > 0) {
                callerSSA.memSSAUsers[n_i.second].insert(formal[n]);
                calleeSSA.memSSADefs[formal[n]].insert(n_i.second);
              }
            }

            // Connects from callee back to the caller.
            auto& callsiteRet = callerSSA.callRetArgsMergePoints[call_mut];
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

              if(fcp.argCopy.count(formal) > 0) {

                Instruction *copyInst = fcp.argCopy[formal];
                fcp.incomingOfArgOrRet[copyInst].insert(actual);

                Instruction *defInst = nullptr;
                if(Instruction *inst = dyn_cast<Instruction>(actual)) {
                  defInst = inst;
                } else if(fcp.argCopy.count(actual) > 0) {
                  defInst = fcp.argCopy[actual];
                }

#if 0 // Move it
                else {
                  errs() << __FILE__ << ":" << __LINE__ << " Warning: skip unsupported actual arguments: " << *actual << "\n";
                }
#endif

                if(defInst != nullptr) {
                  fcp.defuseEdges[defInst].insert(copyInst);
                  fcp.usedefEdges[copyInst].insert(defInst);
                }
              }

              i++;
            }

            // Connects returned values of the callee to the CallInst
            for(auto inst_ite = inst_begin(callee); inst_ite != inst_end(callee); inst_ite++) {
              if(auto ret = dyn_cast<ReturnInst>(&*inst_ite)) {
                if(auto retVal = ret->getReturnValue()) {
                  if(retVal->getType()->isPointerTy()) {
                    fcp.incomingOfArgOrRet[call].insert(retVal);

                    Instruction *defInst = nullptr;
                    if(Instruction *inst = dyn_cast<Instruction>(retVal)) {
                      defInst = inst;
                    } else if(fcp.argCopy.count(retVal) > 0) {
                      defInst = fcp.argCopy[retVal];
                    }

                    if(defInst != nullptr) {
                      fcp.defuseEdges[defInst].insert(call);
                      fcp.usedefEdges[call].insert(defInst);
                    }
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