
import std.stdio;

int fib(int n){
  if(n<2)
    return n;
  else
    return fib(n-1) + fib(n-2);
}

void main(){
  for(int i=0; i<35; ++i)
    writefln("n=%d => %d", i, fib(i));
}
