
// infinitlee
public final class Padding3{
  public static void main(String[] args){
    for(int i=0; i<1000000; ++i)
      pad("abc", 50);
  }
  public static String pad(String str, int size){
    return String.format("%-" + Integer.toString(size) + "s", str);
  }
}
