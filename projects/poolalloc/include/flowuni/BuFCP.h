//
// Created by 杨至轩 on 4/26/17.
//

#ifndef POOLALLOC_BUFCP_H
#define POOLALLOC_BUFCP_H

#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/IR/Dominators.h"
#include "dsa/DataStructure.h"
#include "flowuni/MemSSA.h"
#include "flowuni/LocalFCP.h"

#include <set>
#include <map>
#include <unordered_map>
#include <queue>


namespace llvm {
  struct BuFCP: public ModulePass {
    static char ID;

    void getAnalysisUsage(AnalysisUsage &AU) const override;

    bool runOnModule(Module &M) override;

    BuFCP();

    // Map function to the number of the SCC the function belongs to.
    std::unordered_map<Function*, int> funcSccNum;

    // Number of SCC in the module.
    int sccCount;

    // Map (the number of) SCC to a set of its members.
    std::vector<std::unordered_set<Function*>> sccMember;

    // Data-flow analysis for each SCC.
    std::vector<LocalFCP> sccFCP;
  private:
    EquivBUDataStructures* buDSA;
    LocalMemSSAWrapper* memSSA;
    void clear();

    void resolveInSccCalls(Function*);
    void resolveSccCallsArgCopy(int scc, LocalFCP&);

    std::unordered_map<Function*, std::unordered_set<ReturnInst*>> retInstOfFunc;
  };
}

#endif //POOLALLOC_BUFCP_H
