//
// Created by 杨至轩 on 3/26/17.
//

#ifndef POOLALLOC_FLOWUNI_H
#define POOLALLOC_FLOWUNI_H

#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/IR/Dominators.h"
#include "dsa/DataStructure.h"

#include <unordered_map>
#include <unordered_set>

namespace llvm {

  struct LocalMemSSA: public FunctionPass {
    static char ID;
    LocalMemSSA();
    void getAnalysisUsage(AnalysisUsage &AU) const override;
    bool runOnFunction(Function &F) override;

    // Value-s treated as resources in the local phase (global variables, pointer arguments, alloca-s)
    std::unordered_set<Value*> resources;

    // Maps each StoreInst/CallInst to its users
    std::unordered_map<Instruction*, std::unordered_set<Instruction*>> memSSAUsers;

    // Reverse graph of 'memSSAUsers'. (i.e. mapping each Instruction to definitions it used)
    std::unordered_map<Instruction*, std::unordered_set<Instruction*>> memSSADefs;

    // For each BasicBlock, maps each memory object to its fake phi-node, if exists
    std::unordered_map<BasicBlock*, std::unordered_map<DSNode*, PHINode*>> phiNodes;

    // Dump the memory SSA results as a DOT graph file
    void dump();

#if 0 // Prepared to be removed or generalized to be union of any two iterators
    // A virtual iterator for the union of used definitions in the CFG and in the memory SSA.
    struct MemSSAPredIterator {
      User::value_op_iterator ite1;
      std::unordered_set<Instruction*>::iterator ite2;

      Value* operator*() const;

      Value* operator->() const;

      bool operator==(const MemSSAPredIterator&) const;
      bool operator!=(const MemSSAPredIterator&) const;

      MemSSAPredIterator& operator++();

      MemSSAPredIterator(User::value_op_iterator,
                         User::value_op_iterator,
                         std::unordered_set<Instruction*>::iterator);

      User::value_op_iterator ite1End;

      static std::unordered_set<Instruction*> emptySet;
    };

    // Return a iterator to the union of I->value_op_begin() and memSSADefs[I].begin()
    MemSSAPredIterator memssa_pred_begin(Instruction*);
    MemSSAPredIterator memssa_pred_end(Instruction*);

#endif

  private:
    // All DSNode-s reachable from the actual arguments of a CallInst
    std::unordered_map<CallInst*, std::set<DSNode*>> memModifiedByCall;

    // Corresponding DSNodes of 'resources'
    std::unordered_set<DSNode*> memObjects;

    // Information of required passes.
    LocalDataStructures *localDSA;
    EquivBUDataStructures *buDSA;
    DominanceFrontier *domFrontiers;
    DominatorTree *domTree;
    DSGraph *dsgraph;
    Function *func;

    void buildSSARenaming(std::map<DSNode *, std::vector<Instruction *>> &def, BasicBlock *bb);
    bool aliasResource(Value *v);

    // Insert fake PhiNodes into the function for debugging usage.
    void showPhiNodes();
    // Remove fake PhiNodes from the function to keep the function unchanged.
    void hidePhiNodes();

    // Clear between functions
    void clear();
  };


}

#endif //POOLALLOC_FLOWUNI_H
