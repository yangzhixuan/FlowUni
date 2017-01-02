//
// This file implements derived classes of DataFlowAnalysis (concrete analysis)
//
//

#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/CFG.h"
#include "llvm/Support/Format.h"
#include "LeakPlug.h"
#include "DataFlowAnalysis.h"


#include <algorithm>
#include <vector>
#include <set>
#include <map>

using namespace llvm;
using std::vector;

namespace leakplug{

    // Some common util functions
    // ===================================
    //
    void LeakAnalysis::intersect(InstSet& a, const InstSet& b) {
        for(auto ite = a.begin(); ite != a.end(); ) {
            if(find(b.begin(), b.end(), *ite) == b.end()) {
                ite = a.erase(ite);
            } else {
                ++ite;
            }
        }
    }

    // Implementation for AllocatedMalloc
    // ===================================
    //
    LeakAnalysis::AllocatedMalloc::AllocatedMalloc(SimplifiedCFG& c) 
        : LeakAnalysis::DataFlowAnalysis<InstSet>(c) {

    }

    void LeakAnalysis::AllocatedMalloc::initialization() {
        // entryT is empty set
        // top is the universal set (all malloc() call sites)
        for(const auto& m : cfg.mallocCallSites) {
            top.insert(m.first);
        }
        DataFlowAnalysis<InstSet>::initialization();
    }

    void LeakAnalysis::AllocatedMalloc::meet(InstSet& a, const InstSet& b) {
        intersect(a, b);
    }

    void LeakAnalysis::AllocatedMalloc::transform(const Instruction* node, InstSet& x) {
        if(auto *inst = dyn_cast<CallInst>(node)) {
            const Value *calledFunc = inst->getCalledValue();
            if(calledFunc == cfg.analysis.mallocF) {
                x.insert(node);
            }
        }
    }

    // Implementation for NotFreedMalloc
    // ===================================
    //
    LeakAnalysis::NotFreedMalloc::NotFreedMalloc(SimplifiedCFG& c) 
        : LeakAnalysis::DataFlowAnalysis<InstSet>(c) {

    }

    void LeakAnalysis::NotFreedMalloc::initialization() {
        // both entry and top are the universal set (all malloc() call sites)
        for(const auto& m : cfg.mallocCallSites) {
            entryT.insert(m.first);
            top.insert(m.first);
        }
        DataFlowAnalysis<InstSet>::initialization();
    }

    void LeakAnalysis::NotFreedMalloc::meet(InstSet& a, const InstSet& b) {
        intersect(a, b);
    }

    void LeakAnalysis::NotFreedMalloc::transform(const Instruction* node, InstSet& x) {
        if(auto *inst = dyn_cast<CallInst>(node)) {
            const Value *calledFunc = inst->getCalledValue();
            if(calledFunc == cfg.analysis.freeF) {
                // remove all possible malloc() maybe freed by this free() call
                const auto& resources = cfg.mayPointsTo[inst->getArgOperand(0)];
                for(auto r : resources) {
                    x.erase(r);
                }
            }
        }
    }

    // Implementation for UnusedAfter
    // ===================================
    //
    LeakAnalysis::UnusedAfter::UnusedAfter(SimplifiedCFG& c) 
        : LeakAnalysis::DataFlowAnalysis<InstSet>(c, true) {
        // notice that we perform backward analysis by passing 'true' to base class
    }

    void LeakAnalysis::UnusedAfter::initialization() {
        // both top and entryT are the universal set
        for(const auto& m : cfg.mallocCallSites) {
            entryT.insert(m.first);
            top.insert(m.first);
        }
        DataFlowAnalysis<InstSet>::initialization();
    }

    void LeakAnalysis::UnusedAfter::meet(InstSet& a, const InstSet& b) {
        intersect(a, b);
    }

    void LeakAnalysis::UnusedAfter::transform(const Instruction* node, InstSet& x) {
        // remove all possible malloc()s maybe be used/free()d
        const Value *ptr = nullptr;
        if(auto *inst = dyn_cast<StoreInst>(node)) {
            ptr = inst->getPointerOperand();
        } else if (auto *inst = dyn_cast<LoadInst>(node)){
            ptr = inst->getPointerOperand();
        } else if (auto *inst = dyn_cast<CallInst>(node)) {
            const Value *calledFunc = inst->getCalledValue();
            if(calledFunc == cfg.analysis.freeF) {
                ptr = inst->getArgOperand(0);
            }
        }
        if(ptr) {
            const auto& resources = cfg.mayPointsTo[ptr];
            for(auto r : resources) {
                x.erase(r);
            }
        }
    }

    raw_ostream& operator<<(raw_ostream& os, const LeakAnalysis::InstSet& iset) {
        os << " [ ";
        for(auto i : iset) {
            os << *i << ", ";
        }
        os << " ] ";
        return os;
    }
}
