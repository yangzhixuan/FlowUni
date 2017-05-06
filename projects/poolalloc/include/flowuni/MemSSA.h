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

  struct LocalMemSSA {
    friend struct LocalMemSSAWrapper;

    bool runOnFunction(Function &F);

    // Maps each StoreInst/CallInst to its users
    std::unordered_map<Instruction*, std::unordered_set<Instruction*>> memSSAUsers;

    // Reverse graph of 'memSSAUsers'. (i.e. mapping each Instruction to definitions it used)
    std::unordered_map<Instruction*, std::unordered_set<Instruction*>> memSSADefs;

    // For each BasicBlock, maps each memory object to its fake phi-node, if exists
    std::unordered_map<BasicBlock*, std::unordered_map<DSNode*, PHINode*>> phiNodes;

    // DSNodes for all arguments, including explicit arguments (formal arguments)
    // and implicit arguments (memory objects reachable from explicit arguments).
    std::unordered_set<DSNode*> arguments;

    // DSNodes reachable from globals. They are tracked together for simplicity.
    std::unordered_set<DSNode*> globals;

    // DSNodes reachable from the returned pointer.
    std::unordered_set<DSNode*> returnedMem;

    // For all arguments (both explicit and implicit), there is a fake phi inst for merging incoming values.
    std::unordered_map<DSNode*, PHINode*> argIncomingMergePoint;

    // For all memory objects should be inlined into caller (returned pointer, arguments), we record the last
    // definition of it so that we can splice the memory SSA together in the inter-procedural phase.
    std::unordered_map<DSNode*, Instruction*> retMemLastDef;

    // For each function call and each of the argument being passed by the CallInst, there is a fake phi inst for
    // returning from the callee.
    std::unordered_map<CallInst*, std::unordered_map<DSNode*, PHINode*>> callRetMemMergePoints;
    std::unordered_map<CallInst*, std::unordered_map<DSNode*, Instruction*>> callArgLastDef;

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

    static DSNode* GlobalsLeader;

  private:
    // All DSNode-s reachable from the actual arguments of a CallInst
    std::unordered_map<CallInst*, std::set<DSNode*>> memModifiedByCall;

    // Corresponding DSNodes of 'resources'
    std::unordered_set<DSNode*> memObjects;

    // Information of required passes.
    DataStructures *dsa;
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

  struct LocalMemSSAWrapper : public ModulePass {
    static char ID;
    LocalMemSSAWrapper();
    void getAnalysisUsage(AnalysisUsage &AU) const override;
    bool runOnModule(Module &M) override;

    std::unordered_map<const Function*, LocalMemSSA> ssa;

  private:
    LocalMemSSA localMemSSA;
  };
}

#endif //POOLALLOC_FLOWUNI_H
