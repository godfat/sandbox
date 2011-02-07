
// first draft
public final class Padding1{
  public static void main(String[] args){
    for(int i=0; i<400000; ++i)
      pad("abc", ' ', 50);
    for(int i=0; i<400000; ++i)
      pad("abc", ' ', (int)(Math.random()*100));
  }
  public static String pad(String str, char ch, int size){
    int length = str.getBytes().length;
    if(length >= size) return str;

    char[] chars = new char[size-length];
    java.util.Arrays.fill(chars, ch);
    return str + new String(chars);
  }
}
