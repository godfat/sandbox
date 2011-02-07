
// pao0111
public final class Padding5{
  public static void main(String[] args){
    for(int i=0; i<400000; ++i)
      padding("abc", 50);
    for(int i=0; i<400000; ++i)
      padding("abc", (int)(Math.random()*100));
  }
  private static char[] b = new char[0];
  private static String padding(String text , int size){
    if(size <= text.length()) return text;

    if(b.length != size){
      b = new char[size];
      java.util.Arrays.fill(b , ' ');
    }
    char[] a = text.toCharArray();
    System.arraycopy(a, 0, b, 0, a.length);
    String c = new String(b);
    java.util.Arrays.fill(b, 0, a.length, ' ');
    return c;
  }
}
