
// with cache
public final class Padding4{
  private static String Spaces = "                                                                                                    ";
  public static void main(String[] args){
    for(int i=0; i<1000000; ++i)
      pad("abc", 50);
  }
  public static String pad(String str, int size){
    int length = str.getBytes().length;
    if(length >= size)
      return str;
    else
      return str + Spaces.substring(0, size-length-1);
  }
}
