#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Support/Format.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "LeakPlug.h"
#include "DataFlowAnalysis.h"

#include <algorithm>
#include <vector>
#include <queue>
#include <set>
#include <map>

using namespace llvm;
using std::vector;

namespace leakplug{

    // ======================= Definition for LeakAnalysis =============================
    //
    // =================================================================================

    LeakAnalysis::LeakAnalysis(LeakPlug *pass, Function &Fref) : pass(pass), F(&Fref), cfg(*this) {
        errs() << "Analysis on: " << F->getName() << '\n';
        AA = & pass->getAnalysis<AliasAnalysis>();
        M = F->getParent();

        // get the malloc() function in the module
        Type *BPTy = Type::getInt8PtrTy(F->getContext());
        Type *Int64Ty = Type::getInt64Ty(F->getContext());
        mallocF = M->getOrInsertFunction("malloc", BPTy, Int64Ty, nullptr);
        errs() << "Address of malloc is " << mallocF << "\n"; 

        // get the free() function in the same manner
        Type *voidTy = Type::getVoidTy(F->getContext());
        freeF = M->getOrInsertFunction("free", voidTy, BPTy, nullptr);
        errs() << "Address of free is " << freeF << "\n";
    }

    const char* aaResult(AliasAnalysis::AliasResult r) {
        switch(r) {
            case 0:
                return "no alias";
            case 1:
                return "may alias";
            case 2:
                return "partial alias";
            case 3:
                return "must alias";
            default:
                return "<INVALID ALIAS RESULT>";
        }
    }

    LeakAnalysis::SimplifiedCFG::Node::Node(const Instruction* i) : inst(i) {

    }

    void LeakAnalysis::runAnalysis() {
        // Build the simplified CFG for the analysis
        buildCFG();
        if(cfg.mallocCallSites.size() == 0) {
            return;
        }

        allocatedMalloc = make_shared<AllocatedMalloc>(cfg);
        allocatedMalloc->initialization();
        allocatedMalloc->runAnalysis();
        errs() << "allocatedMalloc analysis result: \n";
        errs() << *allocatedMalloc << "\n";

        notFreedMalloc = make_shared<NotFreedMalloc>(cfg);
        notFreedMalloc->initialization();
        notFreedMalloc->runAnalysis();
        errs() << "notFreedMalloc analysis result: \n";
        errs() << *notFreedMalloc << "\n";

        unusedAfter = make_shared<UnusedAfter>(cfg);
        unusedAfter->initialization();
        unusedAfter->runAnalysis();
        errs() << "unusedAfter analysis result: \n";
        errs() <<  *unusedAfter << "\n";
    }

    int getLineNumber(const Instruction* I){
        if (const DebugLoc &loc = I->getDebugLoc()) {
            return loc.getLine();
        } else {
            return 0;
        }
    }

    LeakAnalysis::SimplifiedCFG::SimplifiedCFG(const LeakAnalysis& a) : analysis(a) {

    }

    void LeakAnalysis::buildCFG() {
        // Find all malloc() call sites
        for(auto I = inst_begin(F); I != inst_end(F); I++) {
            if(auto *inst = dyn_cast<CallInst>(&*I)) {
                Value *calledFunc = inst->getCalledValue();
                if(calledFunc == mallocF) {
                    errs() << "Find malloc call at " << inst <<" : " << *inst <<"\n";
                    cfg.allSites[inst] = cfg.mallocCallSites[inst] = make_shared<SimplifiedCFG::Node>(inst);
                }
            }
        }
        errs() << "Found " << cfg.mallocCallSites.size() << " malloc calls\n";
        if(cfg.mallocCallSites.size() == 0) {
            return;
        }

        // Find all pointers may point to results of malloc()s
        for(auto I = inst_begin(F); I != inst_end(F); I++) {
            for(const auto& resource : cfg.mallocCallSites) {
                AliasAnalysis::AliasResult res = AA->alias(resource.first, &*I);
                if(res != AliasAnalysis::NoAlias) {
                    errs() << *I << " " << aaResult(res) << " " << *resource.first << "\n";
                    cfg.pointers.insert(&*I);
                    cfg.mayPointsTo[&*I].push_back(resource.first);
                }
            }
        }
        errs() << "Found " << cfg.pointers.size() << " pointers\n";

        // Find all relevant store/load/free() instruction
        for(auto I = inst_begin(F); I != inst_end(F); I++) {
            if(auto *inst = dyn_cast<CallInst>(&*I)) {
                Value *calledFunc = inst->getCalledValue();
                if(calledFunc == freeF) {
                    // We only consider pointers may point to results of malloc()s
                    if(std::find(cfg.pointers.begin(), cfg.pointers.end(), inst->getArgOperand(0)) != cfg.pointers.end()){
                        errs() << "Find free call at " << inst <<" : " << *inst <<"\n";
                        cfg.allSites[inst] = cfg.freeCallSites[inst] = make_shared<SimplifiedCFG::Node>(inst);
                    }
                }
            } else if(auto *inst = dyn_cast<StoreInst>(&*I)) {
                Value *ptrOpr = inst->getPointerOperand();
                if(std::find(cfg.pointers.begin(), cfg.pointers.end(), ptrOpr) != cfg.pointers.end()) {
                    errs() << "Find store at " << inst << " : " << *inst << "\n";
                    cfg.allSites[inst] = cfg.storeSites[inst] = make_shared<SimplifiedCFG::Node>(inst);
                }
            } else if(auto *inst = dyn_cast<LoadInst>(&*I)) {
                Value *ptrOpr = inst->getPointerOperand();
                if(std::find(cfg.pointers.begin(), cfg.pointers.end(), ptrOpr) != cfg.pointers.end()) {
                    errs() << "Find load at " << inst << " : " << *inst << "\n";
                    cfg.allSites[inst] = cfg.loadSites[inst] = make_shared<SimplifiedCFG::Node>(inst);
                }
            }
        }

        // Find all return points
        for(const auto& bb : *F) {
            if(succ_begin(&bb) == succ_end(&bb)) {
                const Instruction *last = bb.getTerminator();
                if(cfg.allSites.find(last) == cfg.allSites.end()) {
                    cfg.allSites[last] = cfg.retSites[last] = make_shared<SimplifiedCFG::Node>(last);
                }
            }
        }

        // Keep all branch point to preserve the CFG structure
        for(const auto& bb : *F) {
            const Instruction *last = bb.getTerminator();
            if(cfg.allSites.find(last) == cfg.allSites.end()) {
                cfg.allSites[last] = make_shared<SimplifiedCFG::Node>(last);
            }
        }

        errs() << "Found " << cfg.freeCallSites.size() << " free calls\n";
        errs() << "Found " << cfg.storeSites.size() << " store sites\n";
        errs() << "Found " << cfg.loadSites.size() << " load sites\n";
        errs() << "Found " << cfg.retSites.size() << " ret sites\n";

        // now we can construct edges between CFG
        int numInsts = 0;
        std::map<const Instruction*, int> instNumber;
        std::map<int, const Instruction*> numberInst;
        for(auto I = inst_begin(F); I != inst_end(F); I++) {
            instNumber[&*I] = numInsts;
            numberInst[numInsts] = &*I;
            numInsts++;
        }
        vector<int> connected(numInsts * numInsts);
        auto index = [&](int i, int j){ 
            return i * numInsts + j; 
        };
        for(int i = 0; i < numInsts; i++) {
            connected[index(i, i)] = 1;
        }

        // Connect instruction with its successors
        for(const auto& bb : *F) {
            const Instruction *last = bb.getTerminator();
            for(auto i = succ_begin(&bb); i != succ_end(&bb); i++) {
                const Instruction* succ_inst = &*((*i)->begin());
                connected[index(instNumber[last], instNumber[succ_inst])] = 1;
            }
            for(auto pi = bb.begin(); &*pi != last; pi++) {
                auto next = pi;
                next++;
                connected[index(instNumber[&*pi], instNumber[&*next])] = 1;
            }
        }

        // FIXME: simplify the graph building algorithm since we don't transit through basic blocks anymore

        // Calculate the transitive closure under unspecial instructions
        for(int k = 0; k < numInsts; k++) {
            if(cfg.allSites.find(numberInst[k]) == cfg.allSites.end()) {
                // transitive through unspecial instructions
                for(int i = 0; i < numInsts; i++) {
                    for(int j = 0; j < numInsts; j++) {
                        connected[index(i, j)] |= connected[index(i, k)] && connected[index(k, j)];
                    }
                }
            }
        }

        // Finally connects between special instructions
        for(const auto& i1 : cfg.allSites) {
            for(const auto& i2: cfg.allSites) {
                if(i1 == i2) {
                    continue;
                }
                if(connected[index(instNumber[i1.first], instNumber[i2.first])]) {
                    i1.second->succ.push_back(i2.second);
                    i2.second->pred.push_back(i1.second);
                }
            }
        }

        // Add entry and exit
        cfg.entry = make_shared<SimplifiedCFG::Node>(nullptr);
        for(const auto& i : cfg.allSites) {
            int entryInst = instNumber[&*(inst_begin(F))];
            if(connected[index(entryInst, instNumber[i.first])]) {
                cfg.entry->succ.push_back(i.second);
                i.second->pred.push_back(cfg.entry);
            }
        }

        cfg.exit = make_shared<SimplifiedCFG::Node>(nullptr);
        for(const auto& i : cfg.retSites) {
            i.second->succ.push_back(cfg.exit);
            cfg.exit->pred.push_back(i.second);
        }

        errs() << cfg << "\n";
    }

    raw_ostream& operator<<(raw_ostream& os, const LeakAnalysis::SimplifiedCFG& cfg) {
        os << "CFG { \n";
        os << "\t" << cfg.allSites.size() << " instructions{\n";
        int numInsts = 0;
        std::map<const Instruction*, int> instNumber;
        for(const auto& i : cfg.allSites) {
            instNumber[i.first] = numInsts;
            os << "\t\t" << numInsts << " (line "<<  getLineNumber(i.first) << ") : " << *i.first << "\n";
            numInsts++;
        }
        os << "\t}\n";

        os << "\tsuccessors{\n";

        os << "\t\tentry : ";
        for(const auto& s : cfg.entry->succ) {
            os << instNumber[s->inst] << "(" << "line " << getLineNumber(s->inst) << ")" << ", ";
        }
        os << "\n";

        for(const auto& i : cfg.allSites) {
            os << "\t\t" << instNumber[i.first]  << " (line "<<  getLineNumber(i.first) << ") : ";
            for(const auto& s : i.second->succ) {
                if(s -> inst) {
                    os << instNumber[s->inst] << "(" << "line " << getLineNumber(s->inst) << ")" << ", ";
                } else {
                    os << "exit ";
                }
            }
            os << "\n";
        }
        os << "\t}\n";
        os << "}\n";
        return os;
    }

    // ======================= Definition for LeakPlug =================================
    //
    // =================================================================================

    LeakPlug::LeakPlug() : FunctionPass(ID) {

    }

    void LeakPlug::getAnalysisUsage(AnalysisUsage &AU) const {
        AU.setPreservesCFG();
        AU.addRequired<AliasAnalysis>();
    }

    bool LeakPlug::runOnFunction(Function &F) {
        LeakAnalysis la(this, F);
        la.runAnalysis();
        if(la.cfg.mallocCallSites.size() == 0) {
            return 0;
        }
        // Leak fixing on IR

        // Strategy: Breath-first search from the entry to find edges satifying
        // a malloc() must be allocated, must not be freed before this edge and
        // never used after this edge. To fix this leak, we insert a free() call
        // on this edge. A new BasicBlock will be created unless the head node
        // of the edge has unique successor or the tail node has unique predecessor.
        std::queue< std::shared_ptr<LeakAnalysis::SimplifiedCFG::Node> > queue;
        std::map<const Instruction*, bool> visited;
        for(const auto& pnode: la.cfg.entry->succ) {
            queue.push(pnode);
            visited[pnode->inst] = true;
        }

        int modified = 0;
        while(queue.size() > 0) {
            auto pnode = queue.front();
            queue.pop();

            // FIXME If we insert free() on every out edge of the node, we can merge
            // all these free()s (by inserting directly after the node)
            for(auto psucc : pnode->succ) {
                if(psucc->inst == nullptr) {
                    // it's the virtual exit node. Ignore.
                    continue;
                }
                LeakAnalysis::InstSet leak(la.allocatedMalloc->data[pnode->inst]);
                LeakAnalysis::intersect(leak, la.notFreedMalloc->data[pnode->inst]);
                LeakAnalysis::intersect(leak, la.unusedAfter->data[psucc->inst]);
                if(leak.size() > 0) {
                    for(const Instruction* r : leak) {
                        errs() << "Found a fixable leak " << *r << " (line " << getLineNumber(r) << ") , ";
                        errs() << "fix between " << *pnode->inst << " (line " << getLineNumber(pnode->inst) << ") and  ";
                        errs() << *psucc->inst << " (line " << getLineNumber(psucc->inst) << ")\n";
                        freeOnEdge(la, pnode, psucc, (Instruction*)r);
                        modified = 1;
                        // Update data flow analysis results
                        LeakAnalysis::InstSet pnodeData = la.unusedAfter->data[pnode->inst];
                        pnodeData.erase(r);
                        la.unusedAfter->updateData(pnode->inst, pnodeData);

                        LeakAnalysis::InstSet psuccData = la.notFreedMalloc->data[psucc->inst];
                        psuccData.erase(r);
                        la.notFreedMalloc->updateData(psucc->inst, psuccData);
                    }
                }

                if(!visited[psucc->inst]) {
                    queue.push(psucc);
                    visited[psucc->inst] = true;
                }
            }
        }
        return modified;
    }

    void LeakPlug::freeOnEdge(const LeakAnalysis& la, LeakAnalysis::PtrNode head, LeakAnalysis::PtrNode tail, Instruction* resourceInst) {
        Value* resource = dyn_cast<CallInst>(resourceInst);
        if(!resource) {
            errs() << "Error! "<<resourceInst<<" is not resource\n";
            return;
        }
        if(head->succ.size() == 1) {
            // If head is a terminator, we insert before it. Otherwise we insert after head
            BasicBlock::const_iterator insertBefore(head->inst);
            if(head->inst->getParent()->getTerminator() != head->inst) {
                insertBefore++;
            }
            CallInst::CreateFree(resource, (Instruction*)&*insertBefore);
            patchSourceCode(la, resource, &*insertBefore);
        } else if(tail->pred.size() == 1) {
            BasicBlock::const_iterator insertBefore(tail->inst);
            CallInst::CreateFree(resource, (Instruction*)&*insertBefore);
            patchSourceCode(la, resource, &*insertBefore);
        } else {
            // TODO insert a BasicBlock in this case
            assert(0);
        }
    }


    // Generate a source code patch for the free call
    // 1. Locate the source code insertion point (which line, column, and in which block?)
    // 2. Find suitable variable
    void LeakPlug::patchSourceCode(const LeakAnalysis& la, Value* resource, const Instruction* insertBefore) {
        const DebugLoc& loc = insertBefore->getDebugLoc();
        errs() << "Patch before " << loc.getLine() << ", " << loc.getCol() << ", ";
        std::set<Value*> irPointers;
        for(const auto& p : la.cfg.pointers) {
            AliasAnalysis::AliasResult res = la.AA->alias(resource, p);
            if(res == AliasAnalysis::MustAlias) {
                irPointers.insert(p);
            }
        }

        bool foundVar = false;
        // Find a source code variable corresponding to any pointer in irPointers
        for(auto I = inst_begin(la.F); I != inst_end(la.F); I++) {
            if(auto *inst = dyn_cast<DbgValueInst>(&*I)) {
                if(irPointers.count(inst->getValue())) {
                    MDLocalVariable* srcVar = inst->getVariable();
                    errs() << "using " << srcVar->getName() << "\n";
                    foundVar = true;
                    break;
                }
            }
        }

        if(!foundVar) {
            errs() << "failed to find any source code variable to use\n";
        }
    }
}

char leakplug::LeakPlug::ID = 0;
static RegisterPass< leakplug::LeakPlug > X("leakplug", "Memory leak fixing", false, false);
