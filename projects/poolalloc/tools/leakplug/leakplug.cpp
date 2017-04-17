#include "llvm/Pass.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Bitcode/ReaderWriter.h"
#include "llvm/Support/DataStream.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/Signals.h"
#include "llvm/Analysis/CallGraph.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/Passes.h"
#include "llvm/Analysis/AliasAnalysis.h"


#include "dsa/DSSupport.h"
#include "dsa/DataStructure.h"
#include "dsa/DSCallGraph.h"

#include "LeakPlug.h"

#include <iostream>
#include <memory>
#include "flowuni/MemSSA.h"
#include "flowuni/LocalFCP.h"

using namespace llvm;

// General options for sc.
static cl::opt<std::string>
InputFilename(cl::Positional, cl::desc("<input bytecode>"), cl::init("-"));

static cl::opt<std::string>
OutputFilename("o", cl::desc("Output filename"), cl::value_desc("filename"));


int main(int argc, const char *argv[])
{
    MemoryEffectAnalysis a;
    // FIXME: add -disable-dsa-stdlib option by default
    cl::ParseCommandLineOptions(argc, argv, " llvm system compiler\n");
    sys::PrintStackTraceOnErrorSignal();

    // Load the module to be compiled...
    std::string ErrorMessage;
    std::unique_ptr<Module> M;
    LLVMContext &Context = getGlobalContext();

    // Use the bitcode streaming interface
    DataStreamer *Streamer = getDataFileStreamer(InputFilename, &ErrorMessage);
    if (Streamer) {
        std::string DisplayFilename;
        if (InputFilename == "-")
            DisplayFilename = "<stdin>";
        else
            DisplayFilename = InputFilename;
        ErrorOr<std::unique_ptr<Module>> MOrErr =
            getStreamedBitcodeModule(DisplayFilename, Streamer, Context);
        M = std::move(*MOrErr);
        M->materializeAllPermanently();
    }

    if (M == nullptr) {
        std::cerr << argv[0] << ": bytecode didn't read correctly.\n";
        return 1;
    }

    legacy::PassManager Passes;


    Passes.add(createBasicAliasAnalysisPass());
    Passes.add(new DominatorTreeWrapperPass());
    Passes.add(new DominanceFrontier());
    Passes.add(new CallGraphWrapperPass());
    Passes.add(new AddressTakenAnalysis());
    Passes.add(new LocalDataStructures());
    Passes.add(new LoopInfoWrapperPass());
    Passes.add(new AllocIdentify());
    Passes.add(new StdLibDataStructures());
    Passes.add(new BUDataStructures());
    Passes.add(new CompleteBUDataStructures());
    Passes.add(new EquivBUDataStructures());
//    Passes.add(new MemoryEffectAnalysis());
//    Passes.add(new TDDataStructures());
//    Passes.add(new EQTDDataStructures());
    // Passes.add(new leakplug::LeakPlug());
    Passes.add(new LocalMemSSA());
    Passes.add(new LocalFCP());

    // Verify the final result
    Passes.add(createVerifierPass());

    // Run our queue of passes all at once now, efficiently.
    Passes.run(*M.get());

    return 0;
}
