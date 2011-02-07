
public class Fib{
  static private int fib(int n){
    if(n<2)
      return n;
    else
      return fib(n-1) + fib(n-2);
  }
  static public void main(String[] args){
    for(int i=0; i<35; ++i)
      System.out.println("n="+i+" => "+fib(i));
  }
}
