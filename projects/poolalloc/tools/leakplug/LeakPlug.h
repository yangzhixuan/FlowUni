#ifndef __LEAKPLUG_H
#define __LEAKPLUG_H

#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"

#include "dsa/DSSupport.h"
#include "dsa/DataStructure.h"
#include "dsa/DSCallGraph.h"

#define USEDSA

#include <vector>
#include <queue>
#include <set>
#include <map>

namespace leakplug{
    using namespace llvm;
    using std::vector;
    using std::shared_ptr;
    using std::make_shared;

    struct LeakPlug;
    struct LeakAnalysis;

    // LeakAnalysis class is an abstract for a round of data-flow analysis
    struct LeakAnalysis {

        LeakPlug *pass;
        Function *F;
        Module *M;
        AliasAnalysis *AA;
#ifdef USEDSA
        EQTDDataStructures *DSA;
        EquivBUDataStructures *BU_DSA;
        StdLibDataStructures *localDSA;
        MemoryEffectAnalysis *mea;
#endif
        Value *mallocF;
        Value *freeF;

        AliasAnalysis::AliasResult alias(Value* a, Value* b);
        // The simplified CFG only contains malloc/free/store instructions
        struct SimplifiedCFG {
            const LeakAnalysis& analysis;
            struct Node{
                const Instruction *inst;
                vector< shared_ptr<Node> > succ;
                vector< shared_ptr<Node> > pred;
                Node(const Instruction *i);
            };
            std::set<Value*> pointers;
            std::map< const Value*, vector<const CallInst*> > mayPointsTo;
            std::map< const CallInst*, shared_ptr<Node> > mallocCallSites;
            std::map< const CallInst*, shared_ptr<Node> > freeCallSites;
            std::map< const StoreInst*, shared_ptr<Node> > storeSites;
            std::map< const LoadInst*, shared_ptr<Node> > loadSites;
            std::map< const Instruction*, shared_ptr<Node> > retSites;
            std::map< const Instruction*, shared_ptr<Node> > allSites;

            shared_ptr<Node> entry;
            shared_ptr<Node> exit;

            SimplifiedCFG(const LeakAnalysis& a);
        } cfg;
        typedef std::shared_ptr<SimplifiedCFG::Node> PtrNode;

        // Base class for data flow analysis
        template<typename T>
        struct DataFlowAnalysis {
            bool backwardAnalysis;
            SimplifiedCFG &cfg;
            T entryT;
            T top;
            std::map< const Instruction*, T > data;
            std::queue< const Instruction* > worklist;
            std::map< const Instruction*, bool > inList;

            virtual void transform(const Instruction* node, T& x) = 0;
            virtual void meet(T& a, const T& b) = 0;
            virtual void initialization();

            void runAnalysis();
            void updateData(const Instruction* node, const T& new_x);

            DataFlowAnalysis(SimplifiedCFG& c, bool backward = false);
        };

        typedef std::set<const Instruction*> InstSet;
        static void intersect(InstSet& a, const InstSet& b);

        // allocated malloc analysis
        struct AllocatedMalloc : public DataFlowAnalysis<InstSet> {
            AllocatedMalloc(SimplifiedCFG& c);
            virtual void initialization() override;
            virtual void transform(const Instruction* node, InstSet& x) override;
            virtual void meet(InstSet& a, const InstSet& b) override;
        };
        std::shared_ptr<AllocatedMalloc> allocatedMalloc;

        struct NotFreedMalloc: public DataFlowAnalysis<InstSet> {
            NotFreedMalloc(SimplifiedCFG& c);
            virtual void initialization() override;
            virtual void transform(const Instruction* node, InstSet& x) override;
            virtual void meet(InstSet& a, const InstSet& b) override;
        };
        std::shared_ptr<NotFreedMalloc> notFreedMalloc;

        struct UnusedAfter: public DataFlowAnalysis<InstSet> {
            UnusedAfter(SimplifiedCFG& c);
            virtual void initialization() override;
            virtual void transform(const Instruction* node, InstSet& x) override;
            virtual void meet(InstSet& a, const InstSet& b) override;
        };
        std::shared_ptr<UnusedAfter> unusedAfter;

        LeakAnalysis(LeakPlug *pass, Function &Fref);
        void runAnalysis();

        private:
        void buildCFG();
    };


    raw_ostream& operator<<(raw_ostream& os, const LeakAnalysis::SimplifiedCFG& cfa);
    template<typename T>
    raw_ostream& operator<<(raw_ostream& os, LeakAnalysis::DataFlowAnalysis<T>& dfa);
    raw_ostream& operator<<(raw_ostream& os, const LeakAnalysis::InstSet& iset);

    // LeakPlug class is the interface to the LLVM infrastructure
    struct LeakPlug: public FunctionPass {
        static char ID;
        LeakPlug();
        void getAnalysisUsage(AnalysisUsage &AU) const override;
        bool runOnFunction(Function &F) override;

        void freeOnEdge(const LeakAnalysis& la, LeakAnalysis::PtrNode head, LeakAnalysis::PtrNode tail, Instruction* resourceInst);
        void patchSourceCode(const LeakAnalysis& la, Value* resource, const Instruction* insertBefore);

        struct Patch {
            std::string filename;
            unsigned line;
            unsigned col;
            std::string str;
        };
        std::vector<Patch> patches;
        virtual ~LeakPlug();
    };

    int getLineNumber(const Instruction* I);
}
#endif
