clang -emit-llvm main.c -c -o main.bc
lli main.bc
llvm-dis main.bc -o main.ll
lli main.ll
llvm-as main.ll -o main.bc
lli main.bc
llc main.bc -o main.s
as main.s -o main.o
ld /usr/lib/libc.dylib /usr/lib/crt1.o main.o -o main
# ld -dynamic-linker /lib/ld-linux-x86-64.so.2 /usr/lib/libc.so /usr/lib/crt1.o /usr/lib/crti.o /usr/lib/crtn.o /usr/lib/libc_nonshared.a main.o -o main
./main
