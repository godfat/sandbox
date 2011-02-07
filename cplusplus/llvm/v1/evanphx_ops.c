
// llvm-gcc-4.2 -emit-llvm -O3 -c evanphx_ops.c -std=c99

#include <stdio.h>

void add(int* ops, int* registers) {
  registers[ops[1]] = registers[ops[2]] + ops[3];
}

void set(int* ops, int* registers) {
  registers[ops[1]] = ops[2];
}

void show(int* ops, int* registers) {
  printf("=> %d\n", registers[ops[1]]);
}
