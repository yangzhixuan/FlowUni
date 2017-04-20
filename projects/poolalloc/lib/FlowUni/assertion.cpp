//
// Created by 杨至轩 on 4/18/17.
//

#include "flowuni/LocalFCP.h"
#include "flowuni/MemSSA.h"
#include "llvm/IR/InstIterator.h"
#include <unordered_set>

using namespace llvm;

namespace {
  // Return true if 'a' is a subset of 'b'
  template<typename T>
  bool isSubset(const T& a, const T& b) {
    for(const auto& e : a) {
      if(b.count(e) == 0) {
        return false;
      }
    }
    return true;
  }

  const char* RED_BEGIN = "\033[1;31m";
  const char* GREEN_BEGIN = "\033[0;32m";
  const char* YELLOW_BEGIN = "\033[0;33m";
  const char* COLOR_END = "\033[0m";
}

void LocalFCP::checkAssertions() {
  for(auto ite = inst_begin(func); ite != inst_end(func); ite++) {
    Instruction *inst = &*ite;
    if(auto call = dyn_cast<CallInst>(inst)) {
      std::string funcName = call->getCalledFunction()->getName();
      if(funcName == "__may_pointTo" || funcName == "__may_pointTo_exactly"
          || funcName == "__print_pointTo") {
        std::unordered_set<Value*> ptrSet, checkedSet;

        Value *ptr = call->getArgOperand(0);
        ptrSet = getPointToSetForVal(ptr);

        if(funcName == "__print_pointTo") {
          errs() << YELLOW_BEGIN << "Point-to for " << COLOR_END << *inst << " {\n";
          for(auto v: ptrSet) {
            errs() << "\t" << PointToGraph::escape(v) << "\n";
          }
          errs() << "}\n";
        } else {
          for(unsigned int i = 1; i < call->getNumOperands(); i++) {
            Value *arg = call->getArgOperand(i);
            auto argPtrSet = getPointToSetForVal(arg);
            for(auto v: argPtrSet) {
              checkedSet.insert(v);
            }
          }

          bool failed = false;
          if(funcName == "__may_pointTo") {
            if(!isSubset(ptrSet, checkedSet)) {
              errs() << RED_BEGIN << "Assertion failed ""at: " << COLOR_END << *inst << "\n";
              failed = true;
            }
          } else if(funcName == "__may_pointTo_exactly") {
            if(!isSubset(ptrSet, checkedSet) || !isSubset(checkedSet, ptrSet)) {
              errs() << RED_BEGIN << "Assertion failed ""at: " << COLOR_END << *inst << "\n";
              failed = true;
            }
          }

          if(failed) {
            errs() << "Point-to Set of checked ptr: {\n";
            for(auto v: ptrSet) {
              errs() << "\t" << PointToGraph::escape(v) << "\n";
            }
            errs() << "}\n";

            errs() << "Point-to Set of all other args: {\n";
            for(auto v: checkedSet) {
              errs() << "\t" << PointToGraph::escape(v) << "\n";
            }
            errs() << "}\n";
          } else {
            errs() << GREEN_BEGIN << "Assertion passed ""for: " << COLOR_END << *inst << "\n";
          }
        }
      }
    }
  }
}
