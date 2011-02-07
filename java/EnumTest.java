
import static java.lang.System.out;
import java.util.Random;
import java.lang.reflect.*;

enum Modifier{
  NORMAL(1.0),
  VERY(2.0),
  MORE_OR_LESS(0.5);

  private static Modifier[] data_;
  static{
    Class self = null; // variable self might not have been initialized
    try{
      self = Class.forName("Modifier");
    }catch(Exception e){out.println("must be typo: " + e);}
    Field[] fields = self.getFields();
    Modifier.data_ = new Modifier[fields.length];
    int i = 0;
    for(Field f: fields){
      try{
        data_[i++] = (Modifier)f.get(self);
      }catch(Exception e){out.println("must be typo: " + e);}
    }
  }
  private final double value;
  private Modifier(double value){
    this.value = value;
  }

  public static Modifier pick(int pos){
    return Modifier.data_[pos];
  }
  public double getValue(){
    return value;
  }
}

public class EnumTest{
  public static void main(String[] args){
    for(int i=0; i<10; ++i)
      out.println(pick().getValue());
  }
  static Modifier pick(){
    return Modifier.pick(Math.abs(new Random().nextInt()) % 3);
  }
}
