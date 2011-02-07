
// clang -emit-llvm -O3 -c ops.c -std=c99

#include <stdio.h>

void add(int* registers, int const* ops){
  registers[ops[1]] = registers[ops[2]] + ops[3];
}

void set(int* registers, int const* ops){
  registers[ops[1]] = ops[2];
}

void show(int* registers, int const* ops){
  printf("=> %d\n", registers[ops[1]]);
}
