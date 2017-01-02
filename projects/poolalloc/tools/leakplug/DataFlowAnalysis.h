//
// This file implements DataFlowAnalysis tempalate base class
//
//

#ifndef __DATAFLOWANALYSIS__
#define __DATAFLOWANALYSIS__

#include "LeakPlug.h"
namespace leakplug{
    template<typename T>
    LeakAnalysis::DataFlowAnalysis<T>::DataFlowAnalysis(LeakAnalysis::SimplifiedCFG& cfg, bool backward)
        :  backwardAnalysis(backward), cfg(cfg){

    }

    template<typename T>
    void LeakAnalysis::DataFlowAnalysis<T>::initialization() {
        data.clear();
        for(const auto& i: cfg.allSites) {
            worklist.push(i.first);
            inList[i.first] = true;
            data[i.first] = top;
        }
        // Instruction* for entry is nullptr
        data[nullptr] = entryT;
    }

    template<typename T>
    void LeakAnalysis::DataFlowAnalysis<T>::runAnalysis() {
        // Use non-static member pointer to reuse code for backward analysis
        auto pred = &LeakAnalysis::SimplifiedCFG::Node::pred;
        auto succ = &LeakAnalysis::SimplifiedCFG::Node::succ;
        if(backwardAnalysis) {
            std::swap(pred, succ);
        }
        while(worklist.size() > 0) {
            const Instruction* node = worklist.front();
            worklist.pop();
            inList[node] = false;

            T m(top);
            for(const auto& pred: (*cfg.allSites[node]).*pred) {
                meet(m, data[pred->inst]);
            }
            transform(node, m);
            if(m != data[node]) {
                data[node] = m;
                for(const auto& succ : (*cfg.allSites[node]).*succ) {
                    // if succ->inst is nullptr, it is the exit and we want to ignore it
                    if(succ->inst && !inList[succ->inst]) {
                        worklist.push(succ->inst);
                        inList[succ->inst] = true;
                    }
                }
            }
        }
    }

    // Change the associate data for node to new_x and update the data flow analysis.
    // Note that we don't need to rerun the whole analysis if the new_x is not greater than
    // the original data (i.e. meet(new_x, old_x) == new_x).
    template<typename T>
    void LeakAnalysis::DataFlowAnalysis<T>::updateData(const Instruction* node, const T& new_x) {
        // FIXME In LeakPlug we never updateData to greater one. This check can be removed for efficiency.
        auto tmp(new_x);
        meet(tmp, data[node]);
        if(tmp == new_x) {
            data[node] = new_x;
            const auto& seeds = backwardAnalysis ? cfg.allSites[node]->pred : cfg.allSites[node]->succ;
            for(const auto& succ : seeds) {
                if(succ->inst) {
                    worklist.push(succ->inst);
                    inList[succ->inst] = true;
                }
            }
            runAnalysis();
        } else {
            // TODO rerun the analysis. 
            // This should not happen in our case
            assert(0);
        }
    }

    template<typename T>
    raw_ostream& operator<<(raw_ostream& os, LeakAnalysis::DataFlowAnalysis<T>& dfa) {
        os << "DFA { \n";
        const LeakAnalysis::SimplifiedCFG& cfg = dfa.cfg;
        os << "\t" << cfg.allSites.size() << " instructions{\n";
        int numInsts = 0;
        std::map<const Instruction*, int> instNumber;
        for(const auto& i : cfg.allSites) {
            instNumber[i.first] = numInsts;
            os << "\t\t" << numInsts << " (line "<<  getLineNumber(i.first) << ") : " << *i.first << "\n";
            numInsts++;
        }
        os << "\t}\n";

        if(dfa.backwardAnalysis) {
            os << "\tbackward analysis\n";
        }

        os << "\tdata{\n";

        os << (dfa.backwardAnalysis ? "\t\texit: " : "\t\tentry : ") << dfa.entryT << "\n";

        for(const auto& i : cfg.allSites) {
            os << "\t\t" << instNumber[i.first] << " (line " <<  getLineNumber(i.first) << ") : "<< dfa.data[i.first] << "\n";
        }
        os << "\t}\n";
        os << "}\n";
        return os;
    }
}

#endif
