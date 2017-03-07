cmake_minimum_required(VERSION 3.3)
project(poolalloc)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES
    include/dsa/AddressTakenAnalysis.h
    include/dsa/AllocatorIdentification.h
    include/dsa/CallTargets.h
    include/dsa/DataStructure.h
    include/dsa/DSCallGraph.h
    include/dsa/DSGraph.h
    include/dsa/DSGraphTraits.h
    include/dsa/DSNode.h
    include/dsa/DSSupport.h
    include/dsa/EntryPointAnalysis.h
    include/dsa/keyiterator.h
    include/dsa/stl_util.h
    include/dsa/super_set.h
    include/dsa/svset.h
    include/dsa/TypeSafety.h
    lib/DSA/AddressTakenAnalysis.cpp
    lib/DSA/AllocatorIdentification.cpp
    lib/DSA/Basic.cpp
    lib/DSA/BottomUpClosure.cpp
    lib/DSA/CallTargets.cpp
    lib/DSA/CMakeLists.txt
    lib/DSA/CompleteBottomUp.cpp
    lib/DSA/DataStructure.cpp
    lib/DSA/DataStructureStats.cpp
    lib/DSA/DSCallGraph.cpp
    lib/DSA/DSGraph.cpp
    lib/DSA/DSTest.cpp
    lib/DSA/EntryPointAnalysis.cpp
    lib/DSA/EquivClassGraphs.cpp
    lib/DSA/GraphChecker.cpp
    lib/DSA/Local.cpp
    lib/DSA/Makefile
    lib/DSA/MemoryEffect.cpp
    lib/DSA/Printer.cpp
    lib/DSA/README
    lib/DSA/SanityCheck.cpp
    lib/DSA/StdLibPass.cpp
    lib/DSA/TopDownClosure.cpp
    lib/DSA/TypeSafety.cpp
    tools/leakplug/DataFlowAnalysis.cpp
    tools/leakplug/DataFlowAnalysis.h
    tools/leakplug/leakplug.cpp
    tools/leakplug/LeakPlug.h
    tools/leakplug/Makefile
    tools/leakplug/World.cpp)

add_executable(poolalloc ${SOURCE_FILES})
include_directories(include)
