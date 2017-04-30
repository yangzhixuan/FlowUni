//
// Created by 杨至轩 on 3/31/17.
//

#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/CFG.h"
#include "dsa/DSGraph.h"

#include "flowuni/MemSSA.h"
#include "flowuni/LocalFCP.h"

#include <set>
#include <map>
#include <queue>
#include <fstream>
#include <sstream>

using namespace llvm;
namespace {
  template<typename ... Args>
  std::string string_format( const std::string& format, Args ... args )
  {
    size_t size = snprintf( nullptr, 0, format.c_str(), args ... ) + 1; // Extra space for '\0'
    std::unique_ptr<char[]> buf( new char[ size ] );
    snprintf( buf.get(), size, format.c_str(), args ... );
    return std::string( buf.get(), buf.get() + size - 1 ); // We don't want the '\0' inside
  }

  template<typename T>
  std::string toString(const T& a) {
    std::ostringstream os;
    os << a;
    return os.str();
  }

  template<>
  std::string toString(const Value& I) {
    std::string str;
    llvm::raw_string_ostream rso(str);
    I.print(rso);
    return str;
  }

  template<>
  std::string toString(const Instruction& I) {
    std::string str;
    llvm::raw_string_ostream rso(str);
    I.print(rso);
    return str;
  }

  std::string nodeName(const void* a, std::string prefix = "ptr") {
    std::ostringstream os;
    os << prefix << a;
    return os.str();
  }

  struct IndentLevel{
    std::string chars;
    int level;

    IndentLevel() : chars("\t"), level(0) {}

    void inc() {
      level += 1;
    }

    void dec() {
      level -= 1;
    }

  };

  std::ostream& operator<<(std::ostream& os, const IndentLevel & ind) {
    for(int i = 0; i < ind.level; i++) {
      os << ind.chars;
    }
    return os;
  }
};

void LocalMemSSA::dump(){
  std::ofstream of;
  of.open("memSSA." + func->getName().str() + ".dot", std::fstream::out);

  IndentLevel indent;
  of << "digraph {\n";

  indent.inc();

  // Output all instructions as nodes
  for(auto inst = inst_begin(func); inst != inst_end(func); inst++) {
    const Instruction* addr = &*inst;
    of << indent << string_format("%s[label=\"%s\"];\n", nodeName(addr).c_str(), toString(*inst).c_str());
  }

  // Clustering instructions by BasicBlocks
  int subCount = 0;

  of << indent << string_format("subgraph cluster_%d{\n", subCount);
  subCount++;
  indent.inc();
  of << indent << "label=\"Control Flow Graph\";\n";
  of << indent << "style=\"invis\";\n";

  for(const auto& bb : *func) {
    of << indent << string_format("subgraph cluster_%d{\n", subCount);
    subCount++;
    indent.inc();
    of << indent << "label=\"\";\n";
    of << indent << "style=\"\";\n";
    of << indent;
    for(const auto& inst : bb) {
      of << string_format("%s;", nodeName(&inst).c_str());
    }
    of << "\n";
    indent.dec();
    of << indent << "}\n";
  }
  indent.dec();
  of << indent << "}\n";


  // Output CFG edges
  for(const auto& bb : *func) {

    // In-BasicBlock edges
    auto i1 = bb.begin();
    auto i2 = bb.begin();
    i2++;
    for(; i2 != bb.end(); i1++, i2++) {
      of << indent << string_format("%s -> %s[color=grey];\n", nodeName(&*i1).c_str(), nodeName(&*i2).c_str());

    }

    // Between-BasicBlock edges
    if(bb.begin() != bb.end()) {
      auto last = bb.end();
      last--;
      for(const auto& succBB : successors(&bb)) {
        if(succBB->begin() != succBB->end()) {
          auto first = succBB->begin();
          of << indent << string_format("%s -> %s;\n", nodeName(&*last).c_str(), nodeName(&*first).c_str());
        }
      }
    }
  }

  // MemSSA def-use edges
  for(const auto& i_users : memSSAUsers) {
    Instruction* def = i_users.first;
    for(const auto& use : i_users.second) {
      of << indent << string_format("%s -> %s[color=blue];\n", nodeName(def).c_str(), nodeName(use).c_str());
    }
  }

  // Output all DSNode* as nodes
  for(auto n : memObjects) {
    of << indent << string_format("%s[label=\"%s\"];\n", nodeName(n).c_str(), n->getCaption().c_str());
  }

  // All DSNodes form a subgraph
  of << indent << string_format("subgraph cluster_%d{\n", subCount);
  subCount++;

  indent.inc();
  of<<indent<<"label=\"DSNodes\";\n";
  of<<indent;
  for(auto n : memObjects) {
    of << string_format("%s;", nodeName(n).c_str());
  }
  of << "\n";
  indent.dec();
  of << indent << "}\n";


  // Add edge from memory-related instructions to their corresponding DSNodes
  for(auto inst = inst_begin(func); inst != inst_end(func); inst++) {
    Instruction* addr = &*inst;
    if(auto load = dyn_cast<LoadInst>(addr)) {
      Value *ptr = load->getPointerOperand();
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();
        of << indent << string_format("%s -> %s[style=dotted];\n",
                                      nodeName(load).c_str(), nodeName(n).c_str());
      }
    } else if(auto store = dyn_cast<StoreInst>(addr)) {
      Value *ptr = store->getPointerOperand();
      if(aliasResource(ptr)) {
        DSNode *n = dsgraph->getNodeForValue(ptr).getNode();
        of << indent << string_format("%s -> %s[style=dotted];\n",
                                      nodeName(store).c_str(), nodeName(n).c_str());
      }
    }
#if 0 // CallInsts are replaced by fake phi nodes.
    else if(auto call = dyn_cast<CallInst>(addr)) {
      if(memModifiedByCall.count(call) > 0) {
        for(DSNode* n : memModifiedByCall[call]) {
          // of << indent << string_format("%s -> %s[style=dotted];\n",
          //                               nodeName(call).c_str(), nodeName(n).c_str());
        }
      }
    }
#endif
     else if(auto alloca = dyn_cast<AllocaInst>(addr)) {
      DSNode *n = dsgraph->getNodeForValue(alloca).getNode();
      of << indent << string_format("%s -> %s[style=dotted];\n",
                                    nodeName(n).c_str(), nodeName(alloca).c_str());
    }
  }

  // Add edges between our fake phi nodes and corresponding DSNode.
  for(const auto& kv : phiNodes) {
    for(const auto& np: kv.second) {
      of << indent << string_format("%s -> %s[style=dotted];\n",
                                    nodeName(np.second).c_str(), nodeName(np.first).c_str());
    }
  }

  of << indent << "//Hello\n";
  for(auto& kv : argIncomingMergePoint) {
    of << indent << string_format("%s -> %s[style=dotted];\n",
                                  nodeName(kv.second).c_str(), nodeName(kv.first).c_str());
  }

  of << indent << "//World\n";
  for(auto n : globals) {
    of << indent << string_format("%s -> %s[style=dotted];\n",
                                  nodeName(globalsIncomingMergePoint).c_str(), nodeName(n).c_str());
  }

  of << indent << "//Bar\n";
  for(auto& kv : callRetArgsMergePoints) {
    for(auto& np : kv.second) {
      if(np.first == GlobalsLeader) {
        for(auto n : globals) {
          of << indent << string_format("%s -> %s[style=dotted];\n",
                                        nodeName(np.second).c_str(), nodeName(n).c_str());
        }
      } else {
        of << indent << string_format("%s -> %s[style=dotted];\n",
                                      nodeName(np.second).c_str(), nodeName(np.first).c_str());
      }
    }
  }

  of << "}\n";
  indent.dec();

  of.close();
}


void LocalFCP::dump() {
  std::ofstream of;
  of.open("localFCP." + func->getName().str() + ".dot", std::fstream::out);

  IndentLevel indent;
  of << "digraph {\n";
  indent.inc();

  // Emit all values as nodes.
  for(auto inst: DUGNodes) {
    if(!inst->getType()->isVoidTy()) {
      of << indent << string_format("%s[label=\"%s\"];\n", nodeName(inst).c_str(), toString(*inst).c_str());
    }
  }

  auto resources = this->resources;
  resources.insert(PointToGraph::unspecificSpace);

  // Emit all resources nodes.
  for(auto val: resources) {
    of << indent << string_format("%s[label=\"%s\"];\n", nodeName(val, "r").c_str(), PointToGraph::escape(val).c_str());
  }

  // All values are a subgraph.
  of << indent << string_format("subgraph cluster_%d{\n", 0);
  indent.inc();

  of<<indent<<"label=\"Values\";\n";
  of<<indent;
  for(auto inst: DUGNodes) {
    if(!inst->getType()->isVoidTy()) {
      of << string_format("%s;", nodeName(inst).c_str());
    }
  }
  of << "\n";

  indent.dec();
  of << indent << "}\n";


  // All resources are a subgraph.

  of << indent << string_format("subgraph cluster_%d{\n", 1);
  indent.inc();

  of<<indent<<"label=\"Resources\";\n";
  of<<indent;
  for(auto val: resources) {
    of << string_format("%s;", nodeName(val, "r").c_str());
  }
  of << "\n";

  indent.dec();
  of << indent << "}\n";

  // Edges between resources and values.
  for(auto inst: DUGNodes) {
    if (!inst->getType()->isVoidTy()) {
      for(auto val: resources) {
        Value *to = dataOut[inst].valPointTo;
        if(dataOut[inst].eqClass.equivalent(to, val)) {
          of << indent << string_format("%s -> %s;\n", nodeName(inst).c_str(), nodeName(val, "r").c_str());
        }
      }
    }
  }

  of << "}\n";
  indent.dec();

  of.close();
}

void LocalFCP::dumpSummary() {
  std::unordered_map<Value*, std::unordered_set<Value*>> partition;
  for(auto kv : summary.eqClass.leader) {
    auto leader = summary.eqClass.find(kv.first);
    partition[leader].insert(kv.first);
    partition[leader].insert(leader);
  }
  for(auto kv : summary.pointTo) {
    auto leader = summary.eqClass.find(kv.first);
    partition[leader].insert(leader);
    leader = summary.eqClass.find(kv.second);
    partition[leader].insert(leader);
  }

  std::ofstream of;
  of.open("localFCP.sum." + func->getName().str() + ".dot", std::fstream::out);

  IndentLevel indent;
  of << "digraph {\n";
  indent.inc();

  for(const auto& kv : partition) {
    std::string label;
    for(auto r : kv.second) {
      label = label + PointToGraph::escape(r) + "\\n";
    }
    of << indent << string_format("%s[label=\"%s\"];\n", nodeName(kv.first).c_str(), label.c_str());
  }

  for(const auto& kv : partition) {
    auto to = summary.getPointTo(kv.first);
    if(to != nullptr) {
      auto leader = summary.eqClass.find(to);
      of << indent << string_format("%s -> %s;\n", nodeName(kv.first).c_str(), nodeName(leader).c_str());
    }
  }

  if(summary.valPointTo != nullptr) {
    of << indent << string_format("%s[label=\"%s\"];\n", "ret", "<return>");
    of << indent << string_format("%s -> %s;\n", "ret", nodeName(summary.eqClass.find(summary.valPointTo)).c_str());
  }


  of << "}\n";
  indent.dec();
  of.close();
}
