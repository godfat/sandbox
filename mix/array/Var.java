
import java.util.Vector;

class Variable<T>{
  private T data_;
  Variable(T a){data_ = a;}
  T get(){ return data_; }
  void set(T t){ data_ = t; }
}

class Test<T>{
  public void show(Variable<T> var){
    var.set(var.get());
    System.out.println(var.get());
  }
}

public class Var{
  public static void main(String[] args){
    java.util.List<Integer> int_list = new java.util.ArrayList<Integer>();
    int_list.add(123);

    java.util.List<? extends Object> any_list = int_list;

    Object o = any_list.get(0);

    new Test<Integer>().show(new Variable<Integer>(123));
    new Test<String>().show(new Variable<String>("ab"));
  }
}
