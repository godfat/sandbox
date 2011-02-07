
// pao0111
public final class Padding6{
  public static void main(String[] args){
    for(int i=0; i<400000; ++i)
      pad("abc", ' ', 50);
    for(int i=0; i<400000; ++i)
      pad("abc", ' ', (int)(Math.random()*100));
  }
  private static char[] buffer = new char[0];
  public static String pad(String str, char ch, int size){
    if(buffer.length < size) buffer = new char[size];
    char[] chars = str.toCharArray();
    if(size <= chars.length) return str;

    System.arraycopy(chars, 0, buffer, 0, chars.length);
    java.util.Arrays.fill(buffer, chars.length, size, ch);
    return new String(buffer);
  }
}
