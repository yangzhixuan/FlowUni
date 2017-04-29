//
// Created by 杨至轩 on 4/26/17.
//

#include "dsa/DSGraph.h"
#include "flowuni/MemSSA.h"
#include "flowuni/LocalFCP.h"
#include "flowuni/BuFCP.h"
#include <vector>
#include <map>

using namespace llvm;


namespace{
  static RegisterPass<BuFCP> X("flowuni-bu", "Flow-sensitive unification based points-to analysis", true, true);
}

char BuFCP::ID = 0;

BuFCP::BuFCP() : ModulePass(ID) {

}

void BuFCP::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
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


  // Step3. Post-order inline function summary.
  return false;
}