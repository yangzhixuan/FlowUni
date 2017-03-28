//
// Created by 杨至轩 on 3/26/17.
//

#ifndef POOLALLOC_FLOWUNI_H
#define POOLALLOC_FLOWUNI_H

#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/IR/Dominators.h"
#include "dsa/DataStructure.h"

#include <set>
#include <map>

namespace llvm {

  struct LocalFlowUni: public FunctionPass {
    static char ID;
    LocalFlowUni();
    void getAnalysisUsage(AnalysisUsage &AU) const override;
    bool runOnFunction(Function &F) override;

    // Value-s treated as resources in the local phase (global variables, pointer arguments, alloca-s)
    std::set<Value*> resources;

    // Maps each StoreInst/CallInst to its users
    std::map<Instruction*, std::set<Instruction*>> memSSAUsers;

    // For each BasicBlock, maps each memory object to its fake phi-node, if exists
    std::map<BasicBlock*, std::map<DSNode*, PHINode*>> phiNodes;

  private:
    // All DSNode-s reachable from the actual arguments of a CallInst
    std::map<CallInst*, std::set<DSNode*>> memModifiedByCall;

    // Corresponding DSNodes of 'resources'
    std::set<DSNode*> memObjects;

    // Information of required passes.
    LocalDataStructures *localDSA;
    EquivBUDataStructures *buDSA;
    DominanceFrontier *domFrontiers;
    DominatorTree *domTree;
    DSGraph *dsgraph;

    void buildSSARenaming(std::map<DSNode *, std::vector<Instruction *>> &def, BasicBlock *bb);
    bool aliasResource(Value *v);
  };


}

#endif //POOLALLOC_FLOWUNI_H
