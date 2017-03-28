//===----------------------------------------------------------------------===//
//
//                                                            
//                                                                        
//                                                                         
//                                                                        
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "ECGraphs"
#include "dsa/DataStructure.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "dsa/DSGraph.h"
#include "llvm/IR/CallSite.h"
#include "llvm/Support/Debug.h"
#include "llvm/ADT/SCCIterator.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/EquivalenceClasses.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/FormattedStream.h"
#include <fstream>
#include <queue>
using namespace llvm;

namespace {
  RegisterPass<MemoryEffectAnalysis> X("effect",
                    "Memory Effect Analysis");
}
char MemoryEffectAnalysis::ID = 0;

// runOnModule - 
//
bool MemoryEffectAnalysis::runOnModule(Module &M) {
  // TODO: figure out the meaning of arguments of init()
  init(&getAnalysis<EquivBUDataStructures>(), true, true, false, false);

  //
  // Fetch the DSGraphs for all defined functions within the module.
  //
  std::set<const DSGraph*> visited;
  for (Module::iterator I = M.begin(), E = M.end(); I != E; ++I) {
    if (!I->isDeclaration()) {
      DSGraph* g = getOrCreateGraph(&*I);
      if(visited.count(g) == 0) {
        visited.insert(g);
        _runOnDSGraph(g);
      }
    }
  }

  callgraph.dump();

  return false;
}


// _runOnDSGraph - remove all nodes unreachable from arguments, return value and globals in the DSGraph
//

bool MemoryEffectAnalysis::_runOnDSGraph(DSGraph *g) {
  std::set<const Value*> seeds;
  std::queue<DSNode*> q;
  std::set<DSNode*> visited;

  // For all functions in the SCC, add their arguments in the seeds
  for(auto ret_ite = g->retnodes_begin(); ret_ite != g->retnodes_end(); ret_ite++) {
    const Function* f = ret_ite->first;
    for(const auto &a : f->getArgumentList()) {
      seeds.insert(&a);
      DSNode *n = g->getNodeForValue(&a).getNode();
      if(n) {
        q.push(n);
        visited.insert(n);
      }
    }

  }

  // For all functions in the SCC, add their return nodes in the seeds
  for(auto ret_ite = g->retnodes_begin(); ret_ite != g->retnodes_end(); ret_ite++) {
    DSNode *n = ret_ite->second.getNode();
    if(n) {
      q.push(n);
      visited.insert(n);
    }
  }

  // For all GlobalValue-s used by functions in the SCC, add them in the seeds
  for(auto glb_ite = g->getScalarMap().global_begin(); glb_ite != g->getScalarMap().global_end();
      glb_ite++) {

    seeds.insert(*glb_ite);
    DSNode *n = g->getNodeForValue(*glb_ite).getNode();
    if(n) {
      q.push(n);
      visited.insert(n);
    }

  }

  // Mark all nodes reachable from seeds
  while(!q.empty()) {
    DSNode* n = q.front();
    q.pop();
    for(auto e_ite = n->edge_begin(); e_ite != n->edge_end(); e_ite++) {
      DSNode* succ = e_ite->second.getNode();
      if(succ && visited.count(succ) == 0) {
        q.push(succ);
        visited.insert(succ);
      }
    }
  }

  // Mark all nodes unreachable from seeds
  std::set<DSNode*> unvisited;
  for(auto n_ite = g->node_begin(); n_ite != g->node_end(); n_ite++){
    DSNode *p = &(*n_ite);
    if(visited.count(p) == 0) {
      unvisited.insert(p);
    }
  }


  // Remove all ValueMap entries not in seeds except for GlobalValues
  auto &svmap = g->getScalarMap();
  for(auto vmap_ite = svmap.begin(); vmap_ite != svmap.end(); ) {
      if(seeds.count(vmap_ite->first) == 0) {
        svmap.erase(vmap_ite++);
      } else {
        vmap_ite++;
      }
  }


  // Destroy all unvisited nodes
  for(auto p: unvisited) {
    p->dropAllReferences();
  }

  // Remove them from DSGraph
  for(auto p: unvisited) {
    g->unlinkNode(p);
  }

  g->maskIncompleteMarkers();
  g->markIncompleteNodes(DSGraph::MarkFormalArgs | DSGraph::IgnoreReturnNodes
                         | DSGraph::MarkGlobalsIncomplete | DSGraph::MarkVAStart);

  return false;
}