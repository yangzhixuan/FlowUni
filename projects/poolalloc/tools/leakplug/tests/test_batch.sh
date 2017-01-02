#!/bin/bash

#echo "testing $1"
#bin/clang -emit-llvm -O0 -c -g $1 -o tmp
#bin/opt -mem2reg <tmp > ${1%.c}.bc
#bin/llvm-dis ${1%.c}.bc
#time bin/opt -load build_lib/LLVMWorld.dylib -cfl-aa -tbaa -basicaa -leakplug < ${1%.c}.bc  >  ${1%.c}.fixed.bc
#bin/llvm-dis ${1%.c}.fixed.bc

while read f; do

    echo "testing $f"
    bin/clang -emit-llvm -O0 -c -g $f -o tmp
    bin/opt -mem2reg <tmp > ${f%.c}.bc
    bin/llvm-dis ${f%.c}.bc
    time bin/opt -load build_lib/LLVMWorld.dylib -cfl-aa -tbaa -basicaa -leakplug < ${f%.c}.bc  >  ${f%.c}.fixed.bc
    bin/llvm-dis ${f%.c}.fixed.bc
done < $1
