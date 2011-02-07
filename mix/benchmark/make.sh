
ghc fib.hs -o fib-ghc661 --make

gdc fib.d -o fib-gdc024 --expensive-optimizations --release -O3 -Os

como fib.c -o fib-como438 --c99 -DNDEBUG -O3 -Os
gcc fib.c -o fib-gcc4-apple -std=c99 -DNDEBUG --expensive-optimizations -O3 -Os
gcc-mp-4.2 fib.c -o fib-gcc42-mp -std=c99 -DNDEBUG --expensive-optimizations -O3 -Os
gcc-mp-4.3 fib.c -o fib-gcc43-mp -std=c99 -DNDEBUG --expensive-optimizations -O3 -Os

ocamlopt fib.ml -o fib-ocaml -unsafe

javac Fib.java
gcj-mp-4.2 Fib.java -o fib-gcj42-mp --main=Fib --expensive-optimizations -O3 -Os

mcs fib.cs

clisp -c -ansi fib.lisp -o fib-clisp241
