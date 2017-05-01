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

    sccMember.push_back(std::unordered_set<const Function*>());
    for(auto kv : dsg->getReturnNodes()) {
      errs() << kv.first->getName() << ";";
      funcSccNum[kv.first] = sccCount;
      sccMember[sccCount].insert(kv.first);

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

  // Step3. Post-order inline function summary.
  return false;
}

void BuFCP::resolveInSccCalls(const Function* f) {
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
