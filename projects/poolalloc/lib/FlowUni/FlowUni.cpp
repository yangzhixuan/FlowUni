//
// Created by 杨至轩 on 3/26/17.
//

#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/CFG.h"
#include "dsa/DSGraph.h"

#include "flowuni/FlowUni.h"

#include <set>
#include <map>
#include <queue>

using namespace llvm;

namespace{
  static RegisterPass<LocalFlowUni> X("flowuni", "Flow-sensitive unification based points-to anlaysis", false, false);
}


char LocalFlowUni::ID = 0;

LocalFlowUni::LocalFlowUni() : FunctionPass(ID) {

}

void LocalFlowUni::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AU.addRequired<LocalDataStructures>();
  AU.addRequired<EquivBUDataStructures>();
  AU.addRequired<DominanceFrontier>();
  AU.addRequired<DominatorTreeWrapperPass>();
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


bool LocalFlowUni::runOnFunction(Function &F) {
  localDSA = &getAnalysis<LocalDataStructures>();
  buDSA = &getAnalysis<EquivBUDataStructures>();
  dsgraph = localDSA->getDSGraph(F);
  domFrontiers = &getAnalysis<DominanceFrontier>();
  domTree = &(getAnalysis<DominatorTreeWrapperPass>().getDomTree());

  errs() << "Analysis on: " << F.getName() << "\n";

  // Identify all resources (alloc / pointer args / globals) to be analyzed in the local phase.
  resources.clear();
  for(inst_iterator I = inst_begin(F); I != inst_end(F); I++) {
    if(dyn_cast<AllocaInst>(&*I)) {
      resources.insert(&*I);
    }
#if 0 // pointers returned by functions need not to be processed in the local phase.
    else if(auto ci = dyn_cast<CallInst>(&*I)) {
      if(ci->getType()->isPointerTy()) {
        resources.insert(ci);
      }
    }
#endif
    for(auto op = I->value_op_begin(); op != I->value_op_end(); op++) {
      if(dyn_cast<GlobalVariable>(*op)) {
        resources.insert(*op);
      }
    }
  }
  for(auto arg_ite = F.arg_begin(); arg_ite != F.arg_end(); arg_ite++) {
    if(arg_ite->getType()->isPointerTy()) {
      resources.insert(&*arg_ite);
    }
  }

  errs() << "Resources: {\n";
  for(auto r : resources) {
    errs() << *r << "\n";
  }
  errs() << "}\n";

  // For each load/store instruction, build an SSA form from the results of DSA.
  memSSAUsers.clear();
  memModifiedByCall.clear();
  phiNodes.clear();
  memObjects.clear();

  for(auto val : resources) {
    assert(dsgraph->hasNodeForValue(val) && "hasNodeForValue");
    memObjects.insert(dsgraph->getNodeForValue(val).getNode());
  }

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
          for(auto frontier : frontiers) {
            if(phiNodes[frontier].count(n) == 0) {
              phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "", &*(frontier->begin()));
            }
          }
        }

      } else if(CallInst* call = dyn_cast<CallInst>(&*inst_ite)) {
        // Function calls are treated modifying all resources reachable from their arguments.
        for(auto &arg : call->arg_operands()) {
          Value *ptr = arg.get();
          if(dsgraph->hasNodeForValue(ptr)) {
            DSNode *n = dsgraph->getNodeForValue(ptr).getNode();
            // Traverse from 'n' to all reachable DSNode-s from 'n'. Treating this CallInst modifies all these
            // DSNode-s.
            std::set<DSNode*> reachable = reachableDSNodes(n);
            auto& memModified = memModifiedByCall[call];
            for(auto n : reachable) {
              if(memObjects.count(n) > 0) {
                memModified.insert(n);
                for(auto frontier : frontiers) {
                  if(phiNodes[frontier].count(n) == 0) {
                    phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "", &*(frontier->begin()));
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  // Add PHINode for PHINode inserted earlier until the PHINode set is closed...
  // Flag: 明天把SSA建立好！
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
          phiNodes[frontier][n] = PHINode::Create( Type::getVoidTy(F.getContext()), 0, "", &*(frontier->begin()));
          if(inQueue.count(frontier) == 0) {
            inQueue.insert(frontier);
            bbWithNewPHI.push(frontier);
          }
        }
      }
    }
  }

  errs() << "IR with PHI { \n";
  errs() << F;
  errs() <<"}\n";

  // Step2. resolve all def-use relations of SSA form.
  std::map<DSNode*, std::vector<Instruction*>> lastDef;
  buildSSARenaming(lastDef, &F.getEntryBlock());

  // TODO: testing the code above.
  return false;
}

void LocalFlowUni::buildSSARenaming(std::map<DSNode *, std::vector<Instruction *>> &lastDef, BasicBlock *bb) {
  // Step1. scan instructions in 'bb', adding new definitions and linking usage to its last definition.

  // Number of definitions added for each DSNode. It is recorded for easier stack restoring later.
  std::map<DSNode*, int> stackCount;

  // Process our fake-PHINode first. A PHINode defines a new value.
  for(auto n_p : phiNodes[bb]) {
    lastDef[n_p.first].push_back(n_p.second);
    stackCount[n_p.first] += 1;
  }

  for(auto inst_ite = bb->begin(); inst_ite != bb->end(); inst_ite++) {
    // StoreInst and CallInst use a value and define a new version of it. LoadInst only use a value.
    if(auto store = dyn_cast<StoreInst>(&*inst_ite)) {
      Value *ptr = store->getPointerOperand();
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

        // Reads a old
        if(lastDef[n].size() > 0) {
          Instruction *def = lastDef[n].back();
          memSSAUsers[def].insert(store);
        }

        // Defines a new
        lastDef[n].push_back(store);
        stackCount[n] += 1;
      }
    } else if(auto call = dyn_cast<CallInst>(&*inst_ite)) {
      if(memModifiedByCall.count(call) > 0) {
        for(DSNode *n : memModifiedByCall[call]) {
          // Reads old
          if(lastDef[n].size() > 0) {
            Instruction *def = lastDef[n].back();
            memSSAUsers[def].insert(call);
          }

          // Defines new
          lastDef[n].push_back(call);
          stackCount[n] += 1;
        }
      }
    } else if(auto load = dyn_cast<LoadInst>(&*inst_ite)) {
      Value *ptr = load->getPointerOperand();
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();

        // Reads a old
        if(lastDef.count(n) > 0 && lastDef[n].size() > 0) {
          Instruction *def = lastDef[n].back();
          memSSAUsers[def].insert(load);
        }
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
bool LocalFlowUni::aliasResource(Value* v) {
  if(dsgraph->hasNodeForValue(v)) {
    DSNode *n = dsgraph->getNodeForValue(v).getNode();
    return memObjects.count(n) > 0;
  } else {
    return false;
  }
}

