//
// Created by 杨至轩 on 4/3/17.
//

#ifndef POOLALLOC_LOCALFCP_H
#define POOLALLOC_LOCALFCP_H

#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/IR/Dominators.h"
#include "dsa/DataStructure.h"
#include "flowuni/MemSSA.h"

#include <set>
#include <map>
#include <unordered_map>
#include <queue>


namespace llvm {

  // Tarjan's amortized O(alpha(n)) disjoint-set implementation.
  template<typename T, template<typename ...> class M = std::map>
  struct UnionFind {
    M<T,T> leader;
    M<T, int> rank;
    T find(T);
    bool merge(T, T); // Return true if this requested merging is activated.
    int getRank(T);
    bool equivalent(T, T);
  };

  struct PointToGraph {
    // Equivalent class of resources.
    UnionFind<Value*, std::unordered_map> eqClass;

    // The unique outgoing edge for each equivalent class of resources.
    // Only defined for leader values (i.e. results of find()) in the eqClass.
    std::unordered_map<Value*, Value*> pointTo;

    // The memory object pointed by the value defined by this instruction.
    Value* valPointTo;
    std::unordered_set<Value*> valPointToSets;

    // Get/set the unique outgoing link for the equivalent class 'v' belongs to.
    Value* getPointTo(Value* v);
    Value* setPointTo(Value* v, Value* to);

    // (Recursively) merge the equivalent classes represented by 'x' and 'y'.
    bool mergeRec(Value *x, Value *y);

    // uninitialized memory objects point to 'unspecificiSpace'
    static Value* unspecificSpace;

    // Output an Value. Escape for pesudo Value like 'unspecificSpace'.
    static std::string escape(Value* v);

    PointToGraph();
  };

  struct DeltaPointToGraph {
    enum Type{
      Merge,    // Merge x and y
      PointTo   // Make x point to y
    }type;
    Value *x;
    Value *y;

    DeltaPointToGraph(Type type, Value *x, Value *y);
  };
  DeltaPointToGraph make_pointTo(Value *x, Value *y);
  DeltaPointToGraph make_merge(Value *x, Value *y);

  struct LocalFCP: public FunctionPass {
    static char ID;
    void getAnalysisUsage(AnalysisUsage &AU) const override;
    bool runOnFunction(Function &F) override;
    LocalFCP();

    // Get (a element of) the resource equivalent class pointed by 'x' if exists.
    // Return nullptr otherwise.
    Value *getMemObjectsForVal(Value *x);
    bool hasMemObjectsForVal(Value *x);
    std::unordered_set<Value*> getPointToSetForVal(Value *x);

    // Resources considered in this phase.
    std::unordered_set<Value*> resources;

    // Map each pointer-involved instruction to its corresponding 'partial' point-to graph.
    std::unordered_map<Instruction*, PointToGraph> dataIn;
    std::unordered_map<Instruction*, PointToGraph> dataOut;

    // Def-Use Graph (DUG) nodes (i.e. instructions involved with 'interesting' pointers)
    std::unordered_set<Instruction*> DUGNodes;

    // Def-use edges for DUGNodes
    std::unordered_map<Instruction*, std::unordered_set<Instruction*>> defuseEdges;
    std::unordered_map<Instruction*, std::unordered_set<Instruction*>> usedefEdges;

    // Dump the point-to graph as a DOT file.
    void dump();
  private:
    std::queue<Instruction*> worklist;
    std::unordered_set<Instruction*> inList;

    std::unordered_map<Instruction*, std::vector<DeltaPointToGraph>> dataOutDelta;

    // The difference between the output data and the input data for a DUGNode.
    std::unordered_map<Instruction*, std::vector<DeltaPointToGraph>> dataOutInDiff;

    LocalMemSSA *memSSA;
    Function *func;

    // Clear between function
    void clear();

    // Check whether 'd' has already been emmited/applied to the input data of 'i'
    bool isEmitted(const DeltaPointToGraph& d, Instruction* i);

    // Push all DUGNodes to the worklist in an order consistent with the dominance order.
    // (If 'a' dominates 'b', then 'a' precedes 'b' in the initial worklist)
    void initWorkListDomOrder(BasicBlock *bb, std::unordered_set<BasicBlock*>& visited);

    // Check testing annotations in the code.
    void checkAssertions();

  };

}

#endif //POOLALLOC_LOCALFCP_H
