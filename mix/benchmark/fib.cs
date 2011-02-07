
using System;

class Fib{
  private static int fib(int n){
    if(n<2)
      return n;
    else
      return fib(n-1) + fib(n-2);
  }
  public static int Main(String[] args){
    for(int i=0; i<35; ++i)
      Console.WriteLine("n={0} => {1}", i, fib(i));
    return 0;
  }
}
