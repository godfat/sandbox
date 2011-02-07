
interface N1 {}
interface N2 {}

class A {}
class B extends A implements N1 {}
class C extends A implements N1 {}

class X extends B implements N2 {}
class Y extends C implements N2 {}

public class Ambi{
  public static void main(){
    func(new X());
    func(new Y());
  }
  private static void func(A a){
    System.out.println("A");
  }
  private static void func(N2 a){
    System.out.println("N2");
  }
}
