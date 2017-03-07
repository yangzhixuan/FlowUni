#!/bin/bash

while read f; do
    echo "testing $f"
    bin/clang -emit-llvm -O0 -c -g $f -o ${f%.c}.bc
    bin/llvm-dis ${f%.c}.bc
    time ../../../Debug+Asserts/bin/leakplug ${f%.c}.bc
done < $1
