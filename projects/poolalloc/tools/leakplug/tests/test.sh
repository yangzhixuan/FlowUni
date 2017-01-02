#!/bin/bash

# echo "testing $1"
# bin/clang -emit-llvm -O0 -c -g $1 -o tmp
# bin/opt -mem2reg <tmp > ${1%.c}.bc
# bin/llvm-dis ${1%.c}.bc
# time bin/opt -load build_lib/LLVMWorld.dylib -cfl-aa -tbaa -basicaa -leakplug < ${1%.c}.bc  >  ${1%.c}.fixed.bc
# bin/llvm-dis ${1%.c}.fixed.bc

# echo "testing $1"
# bin/clang -emit-llvm -O0 -c -g $1 -o tmp
# bin/opt <tmp > ${1%.c}.bc
# bin/llvm-dis ${1%.c}.bc
# time bin/opt -load build_lib/LLVMWorld.dylib -cfl-aa -tbaa -basicaa -leakplug < ${1%.c}.bc  >  ${1%.c}.fixed.bc
# bin/llvm-dis ${1%.c}.fixed.bc

echo "testing $1"
bin/clang -emit-llvm -O0 -c -g $1 -o ${1%.c}.bc
bin/llvm-dis ${1%.c}.bc
time ../../../Debug+Asserts/bin/leakplug ${1%.c}.bc
dot -Tjpg eqtd.f.dot -o tmp.jpg
