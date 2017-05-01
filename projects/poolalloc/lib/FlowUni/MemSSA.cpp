//
// Created by 杨至轩 on 3/26/17.
//

#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/CFG.h"
#include "dsa/DSGraph.h"

#include "flowuni/MemSSA.h"

#include <set>
#include <map>
#include <queue>
#include <fstream>
#include <sstream>

using namespace llvm;

namespace{
  static RegisterPass<LocalMemSSAWrapper> X("localMemSSA", "Intraprocedural memory SSA based on Data Structure Analysis", true, true);
}


char LocalMemSSAWrapper::ID = 0;

LocalMemSSAWrapper::LocalMemSSAWrapper() : ModulePass(ID) {

}

void LocalMemSSAWrapper::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AU.addRequired<LocalDataStructures>();
  AU.addRequired<EquivBUDataStructures>();
  AU.addRequired<DominanceFrontier>();
  AU.addRequired<DominatorTreeWrapperPass>();
}

bool LocalMemSSAWrapper::runOnModule(Module &M) {

#define __DBG_MEMSSA

#ifdef __DBG_MEMSSA
  localMemSSA.dsa = &getAnalysis<EquivBUDataStructures>();
  localMemSSA.dsa->print(errs(), &M);
#endif
  for(auto& F: M) {
    if(F.isDeclaration() == false) {
      localMemSSA.func = &F;
      localMemSSA.dsa = &getAnalysis<LocalDataStructures>();
      localMemSSA.dsgraph = localMemSSA.dsa->getDSGraph(F);
      localMemSSA.domFrontiers = &getAnalysis<DominanceFrontier>(F);
      localMemSSA.domTree = &(getAnalysis<DominatorTreeWrapperPass>(F).getDomTree());

      localMemSSA.runOnFunction(F);
      ssa[&F] = localMemSSA;
    }
  }
  return false;
}

namespace {
  void traverse(DSNode *n, std::set<DSNode*>& reached);
  std::set<DSNode*> reachableDSNodes(DSNode *n);

  // Helper function to find all DSNode-s reachable from 'n' in 'g'
  std::set<DSNode*> reachableDSNodes(DSNode *n) {
    std::set<DSNode*> reachable;
    traverse(n, reachable);
    return reachable;
  }

  void traverse(DSNode *n, std::set<DSNode*>& reached) {
    reached.insert(n);
    for(auto edge_ite = n->edge_begin(); edge_ite != n->edge_end(); edge_ite++) {
      DSNodeHandle h = edge_ite->second;
      if(!h.isNull()) {
        DSNode *t = h.getNode();
        if(reached.count(t) == 0) {
          traverse(t, reached);
        }
      }
    }
  }
}

void LocalMemSSA::clear() {
  memSSAUsers.clear();
  memSSADefs.clear();
  phiNodes.clear();
  memModifiedByCall.clear();
  memObjects.clear();
  arguments.clear();
  globals.clear();
  argIncomingMergePoint.clear();
  callRetArgsMergePoints.clear();
  callArgLastDef.clear();
  returnedMem.clear();
  retMemLastDef.clear();
}

DSNode* LocalMemSSA::GlobalsLeader = (DSNode*) "virtual DSNode for globals";

bool LocalMemSSA::runOnFunction(Function &F) {
  clear();

  errs() << "Building LocalMemSSA on: " << F.getName() << "\n";

  for(auto ite = dsgraph->node_begin(); ite != dsgraph->node_end(); ite++) {
    memObjects.insert(&*ite);
  }

  for(auto node_ite = dsgraph->node_begin(); node_ite != dsgraph->node_end(); node_ite++) {
    if (node_ite->isGlobalNode()) {
      globals.insert(&*node_ite);

      auto reachable = reachableDSNodes(&*node_ite);
      for(DSNode* m: reachable) {
        globals.insert(m);
      }
    }
  }

#ifdef __DBG_MEMSSA
  errs() << "Globals size: " << globals.size() << "\n";
#endif


  // For each load/store instruction, build an SSA form from the results of DSA.

  // Step1. place all necessary PHINodes for memory objects
  for(auto bb_ite = F.begin(); bb_ite != F.end(); bb_ite++) {
    const std::set<BasicBlock*> &frontiers = domFrontiers->find(&*bb_ite)->second;

    for(auto inst_ite = bb_ite->begin(); inst_ite != bb_ite->end(); inst_ite++) {
      if(StoreInst* store = dyn_cast<StoreInst>(&*inst_ite)) {
        // If a StoreInst modify a memory object aliasing our 'resources', insert a PHINode at the dominance frontier.
        Value* ptr = store->getPointerOperand();
        if(aliasResource(ptr)) {
          // this StoreInst modifies a memory object aliasing our 'resources'
          DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

          // We track all global DSNodes together so that we replace all of them with the static constant GlobalsLeader.
          if(globals.count(n) > 0) {
            n = GlobalsLeader;
          }

          for(auto frontier : frontiers) {
            if(phiNodes[frontier].count(n) == 0) {
              phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
            }
          }
        }

      } else if(AllocaInst* alloca = dyn_cast<AllocaInst>(&*inst_ite)) {
        // AllocaInst is treated as storing an 'unspecific' value to the memory.
        Value *ptr = alloca;
        if(aliasResource(ptr)) {
          DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

          // We track all global DSNodes together so that we replace all of them with the static constant GlobalsLeader.
          if(globals.count(n) > 0) {
            n = GlobalsLeader;
          }

          for(auto frontier : frontiers) {
            if(phiNodes[frontier].count(n) == 0) {
              phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
            }
          }
        }
      } else if(CallInst* call = dyn_cast<CallInst>(&*inst_ite)) {
        // Function calls are treated modifying all resources reachable from their arguments.

        // Traverse from arguments to all reachable DSNode-s. Treating this CallInst modifies
        // all these DSNode-s.
        auto& memModified = memModifiedByCall[call];
        for(auto &arg : call->arg_operands()) {
          Value *ptr = arg.get();
          if(dsgraph->hasNodeForValue(ptr)) {
            DSNode *n = dsgraph->getNodeForValue(ptr).getNode();
            std::set<DSNode*> reachable = reachableDSNodes(n);
            for(auto n : reachable) {
              if(memObjects.count(n) > 0) {
                if(globals.count(n) > 0) {
                  continue;
                }
                memModified.insert(n);
              }
            }
          }
        }

        if(dsgraph->hasNodeForValue(call)) {
          DSNode *n = dsgraph->getNodeForValue(call).getNode();
          auto reachable = reachableDSNodes(n);

          for (DSNode *n : reachable) {
            if(globals.count(n) > 0) {
              continue;
            }
            memModified.insert(n);
          }
        }

        // Globals are always passed to callee.
        memModified.insert(GlobalsLeader);

        for(DSNode *n : memModified) {
          for(auto frontier : frontiers) {
            if(phiNodes[frontier].count(n) == 0) {
              phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
            }
          }
        }
      } else if(ReturnInst* ret = dyn_cast<ReturnInst>(&*inst_ite)) {
        if(Value *retPtr = ret->getReturnValue()) {
          if(dsgraph->hasNodeForValue(retPtr)) {
            DSNode *n = dsgraph->getNodeForValue(retPtr).getNode();
            auto reachable = reachableDSNodes(n);
            for(DSNode *n : reachable) {
              if(globals.count(n) == 0) {
                returnedMem.insert(n);
              }
            }
          }
        }
      }
    }
  }

  // Add PHINode for PHINode inserted earlier until the PHINode set is closed...
  std::queue<BasicBlock*> bbWithNewPHI;
  std::set<BasicBlock*> inQueue;
  for(const auto& kv : phiNodes) {
    bbWithNewPHI.push(kv.first);
    inQueue.insert(kv.first);
  }
  while(!bbWithNewPHI.empty()) {
    BasicBlock* bb = bbWithNewPHI.front();
    bbWithNewPHI.pop();
    inQueue.erase(bb);

    auto& bbPHIS = phiNodes[bb];
    const auto& frontiers = domFrontiers->find(bb)->second;

    for(auto n_p : bbPHIS) {
      DSNode *n = n_p.first;
      for(BasicBlock* frontier: frontiers) {
        if(phiNodes[frontier].count(n) == 0) {
          phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
          if(inQueue.count(frontier) == 0) {
            inQueue.insert(frontier);
            bbWithNewPHI.push(frontier);
          }
        }
      }
    }
  }

#ifdef __DBG_MEMSSA
  errs() << "IR with PHI { \n";
  errs() << F;
  errs() <<"}\n";
#endif

  // Identify explicit and implicit arguments and create merge points for them.
  for(auto& arg : F.args()) {
    if(dsgraph->hasNodeForValue(&arg)) {
      DSNode *n = dsgraph->getNodeForValue(&arg).getNode();
      std::set<DSNode*> reachable = reachableDSNodes(n);
      for(auto& i : reachable) {
        // Globals are tracked separately with arguments.
        if(globals.count(n) == 0) {
          arguments.insert(i);
        }
      }
    }
  }

  // Globals are similar to arguments, but we sacrificed their sparsity for simplicity so that
  // all globals resources are tracked together.
  if(globals.size() > 0) {
    arguments.insert(GlobalsLeader);
  }

  for(auto arg : arguments) {
    argIncomingMergePoint[arg] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
  }

  // Create merge points for returning from function calls.
  for(auto inst_ite = inst_begin(F); inst_ite != inst_end(F); inst_ite++) {
    if(auto call = dyn_cast<CallInst>(&*inst_ite)) {
      auto& retMergePoint = callRetArgsMergePoints[call];
      for(DSNode *n : memModifiedByCall[call]) {
        retMergePoint[n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "");
      }
    }
  }

  // Step2. resolve all def-use relations of the SSA form.

  std::map<DSNode*, std::vector<Instruction*>> lastDef;

  for(DSNode* arg : arguments) {
    PHINode *phi = argIncomingMergePoint[arg];
    lastDef[arg].push_back(phi);
  }

  buildSSARenaming(lastDef, &F.getEntryBlock());

  // Build reverse graph for convenience.
  for(const auto& i_us : memSSAUsers) {
    for(const auto& user : i_us.second) {
      memSSADefs[user].insert(i_us.first);
    }
  }

  dump();

  return false;
}

void LocalMemSSA::buildSSARenaming(std::map<DSNode *, std::vector<Instruction *>> &lastDef, BasicBlock *bb) {
  // Step1. scan instructions in 'bb', adding new definitions and linking usage to its last definition.

  // Number of definitions added for each DSNode. It is recorded for easier stack restoring later.
  std::map<DSNode*, int> stackCount;

  // Process our fake-PHINode first. A PHINode defines a new value.
  for(auto n_p : phiNodes[bb]) {
    lastDef[n_p.first].push_back(n_p.second);
    stackCount[n_p.first] += 1;
  }

  for(auto inst_ite = bb->begin(); inst_ite != bb->end(); inst_ite++) {
    // Alloca/StoreInst/CallInst use a value and define a new version of it. LoadInst only use a value.
    if(auto store = dyn_cast<StoreInst>(&*inst_ite)) {
      Value *ptr = store->getPointerOperand();
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

        // We track all global DSNodes together so that we replace all of them with the static constant GlobalsLeader.
        if(globals.count(n) > 0) {
          n = GlobalsLeader;
        }

        // Reads an old
        assert(lastDef[n].size() > 0 && "Stored location should have a definition");

        Instruction *def = lastDef[n].back();
        memSSAUsers[def].insert(store);

        // Defines a new
        lastDef[n].push_back(store);
        stackCount[n] += 1;
      }
    } else if(auto alloca = dyn_cast<AllocaInst>(&*inst_ite)) {
      // AllocaInst is treated as storing an 'unspecific' value into the memory.
      Value *ptr = alloca;
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

        // We track all global DSNodes together so that we replace all of them with the static constant GlobalsLeader.
        if(globals.count(n) > 0) {
          n = GlobalsLeader;
        }

        // Reads an old if exists
        if(lastDef[n].size() > 0) {
          Instruction *def = lastDef[n].back();
          memSSAUsers[def].insert(alloca);
        }

        // Defines a new
        lastDef[n].push_back(alloca);
        stackCount[n] += 1;
      }
    } else if(auto call = dyn_cast<CallInst>(&*inst_ite)) {
      if(memModifiedByCall.count(call) > 0) {
        auto& argLastDef = callArgLastDef[call];
        auto& argRetMerge = callRetArgsMergePoints[call];

        for(DSNode *n : memModifiedByCall[call]) {
          assert(argRetMerge.count(n) > 0);

          // Record current 'lastDef' so that we can splice callsite and callee in
          // the inter-procedural phase.

          if(lastDef[n].size() > 0) {
            Instruction *def = lastDef[n].back();
            argLastDef[n] = def;
            memSSAUsers[def].insert(argRetMerge[n]);
          } else {
            // 'n' may be returned by the call, so it may don't have a previous definition.
          }

          // 'lastDef'-s are also connected with the returning merge point so that
          // we can do intra-procedural analysis (function calls are treated as identity functions).
          lastDef[n].push_back(argRetMerge[n]);
          stackCount[n] += 1;
        }
      }
    } else if(auto load = dyn_cast<LoadInst>(&*inst_ite)) {
      Value *ptr = load->getPointerOperand();
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

        // We track all global DSNodes together so that we replace all of them with the static constant GlobalsLeader.
        if(globals.count(n) > 0) {
          n = GlobalsLeader;
        }

        // Reads an old
        assert(lastDef[n].size() > 0);
        Instruction *def = lastDef[n].back();
        memSSAUsers[def].insert(load);
      }
    } else if(dyn_cast<ReturnInst>(&*inst_ite)) {
      // For each argument, record the 'last definition' of it when returning, so that we can splice memory SSA
      // of several functions in the inter-procedural phase.
      for(DSNode* n : arguments) {
        assert(lastDef[n].size() > 0);
        retMemLastDef[n] = lastDef[n].back();
      }

      for(DSNode* n : returnedMem) {
        assert(lastDef[n].size() > 0);
        retMemLastDef[n] = lastDef[n].back();
      }
    }
  }

  // Step2. update PHINodes for successors blocks in the CFG.
  for(BasicBlock *succ : successors(bb)) {
    if(phiNodes.count(succ) > 0) {
      for(auto n_p : phiNodes[succ]) {
        DSNode *n = n_p.first;
        PHINode *p = n_p.second;
        if(lastDef.count(n) > 0) {
          Instruction *def = lastDef[n].back();
          // p->addIncoming(...)
          memSSAUsers[def].insert(p);
        }
      }
    }
  }

  // Step3. Recursively process immediate dominated BasicBlocks.
  if(auto domTreeNode = domTree->getNode(bb)) {
    for(auto child : domTreeNode->getChildren()) {
      buildSSARenaming(lastDef, child->getBlock());
    }
  }

  // Step4. Restore definitions added in this BasicBlock.
  for(auto n_c : stackCount) {
    DSNode *n = n_c.first;
    int c = n_c.second;
    while(c != 0) {
      lastDef[n].pop_back();
      c = c - 1;
    }
  }
}

// Helper function for testing whether 'v' aliasing our 'resources'
bool LocalMemSSA::aliasResource(Value* v) {
  if(dsgraph->hasNodeForValue(v)) {
    DSNode *n = dsgraph->getNodeForValue(v).getNode();
    return memObjects.count(n) > 0;
  } else {
    return false;
  }
}

// Remove our fake PhiNodes from the function
void LocalMemSSA::hidePhiNodes() {
  for(const auto& kv : phiNodes) {
    for(const auto& np: kv.second) {
      np.second->removeFromParent();
    }
  }

  for(auto& kv : argIncomingMergePoint) {
    kv.second->removeFromParent();
  }

  for(auto& kv : callRetArgsMergePoints) {
    for(auto& np : kv.second) {
      np.second->removeFromParent();
    }
  }
}

void LocalMemSSA::showPhiNodes() {
  for(const auto& kv : phiNodes) {
    for(const auto& np: kv.second) {
      kv.first->getInstList().insert(kv.first->getFirstInsertionPt(), np.second);
    }
  }

  for(auto& kv : argIncomingMergePoint) {
    func->getEntryBlock().getInstList().insert(func->getEntryBlock().getFirstInsertionPt(), kv.second);
  }

  for(auto& kv : callRetArgsMergePoints) {
    for(auto& np : kv.second) {
      np.second->insertBefore(kv.first);
    }
  }
}

#if 0 // Prepared to be removed

// --------------------------------------------------------------------------------
// ------ MemSSAPredIterator
// --------------------------------------------------------------------------------

Value* LocalMemSSA::MemSSAPredIterator::operator*() const {
  if(ite1 != ite1End) {
    return *ite1;
  } else {
    return *ite2;
  }
}

Value* LocalMemSSA::MemSSAPredIterator::operator->() const {
  return operator*();
}

LocalMemSSA::MemSSAPredIterator& LocalMemSSA::MemSSAPredIterator::operator++() {
  if(ite1 != ite1End) {
    ++ite1;
  } else {
    ++ite2;
  }
  return *this;
}

LocalMemSSA::MemSSAPredIterator::MemSSAPredIterator(User::value_op_iterator ite1,
                                                    User::value_op_iterator ite1End,
                                                    std::unordered_set<Instruction*>::iterator ite2)
  : ite1End(ite1End), ite1(ite1), ite2(ite2) {

}

LocalMemSSA::MemSSAPredIterator LocalMemSSA::memssa_pred_begin(Instruction *I) {
  if(memSSADefs.count(I) > 0) {
    return MemSSAPredIterator(I->value_op_begin(), I->value_op_end(), memSSADefs[I].begin());
  } else {
    return MemSSAPredIterator(I->value_op_begin(), I->value_op_end(), MemSSAPredIterator::emptySet.end());
  }
}

LocalMemSSA::MemSSAPredIterator LocalMemSSA::memssa_pred_end(Instruction *I) {
  if(memSSADefs.count(I) > 0) {
    return MemSSAPredIterator(I->value_op_end(), I->value_op_end(), memSSADefs[I].end());
  } else {
    return MemSSAPredIterator(I->value_op_end(), I->value_op_end(), MemSSAPredIterator::emptySet.end());
  }
}

bool LocalMemSSA::MemSSAPredIterator::operator==(const MemSSAPredIterator &y) const {
  return ite1 == y.ite1 && ite2 == y.ite2;
}

bool LocalMemSSA::MemSSAPredIterator::operator!=(const MemSSAPredIterator &y) const {
  return !(operator==(y));
}


std::unordered_set<Instruction*> LocalMemSSA::MemSSAPredIterator::emptySet;

#endif
