
class Base{
  public Base test(){
    System.out.println("Base");
    return this;
  }
}

class Derived extends Base{
  public Void test(){
    System.out.println("Derived");
    return null;
  }
}

class TestVoid{
  public static void main(String[] args){
    Base b = new Derived();
    b.test();
  }
}
