
abstract class Padder{
  public String pad_spaces(String str, int size){
    return pad(str, ' ', size);
  }
  public String pad(String str, char ch, int size){return "Not Implemented";}
}

class Padder_silver8250 extends Padder{
  public String pad(String data, char ch, int size){
    int length = data.length();
    StringBuilder sb = new StringBuilder(data);
    for (int i=0 , n=size-length ; i<n ; i++) {
      sb.append(ch);
    }
    return sb.toString();
  }
}

class Padder_godfat_fill extends Padder{
  public String pad(String str, char ch, int size){
    int length = str.length();
    if(length >= size) return str;

    char[] chars = new char[size-length];
    java.util.Arrays.fill(chars, ch);
    return str + new String(chars);
  }
}

class Padder_infinitlee extends Padder{
  public String pad_spaces(String str, int size){
    if(size <= 0) size = 1;
    return String.format("%-" + Integer.toString(size) + "s", str);
  }
}

class Padder_godfat_pre extends Padder{
  private static String Spaces = "                                                                                                                                                                                                        ";
  public String pad_spaces(String str, int size){
    int length = str.length();
    if(length >= size)
      return str;
    else
      return str + Spaces.substring(0, size-length);
  }
}

class Padder_pao0111 extends Padder{
  private char[] b = new char[0];
  public String pad(String text, char ch, int size){
    if(size <= text.length()) return text;

    if(b.length != size){
      b = new char[size];
      java.util.Arrays.fill(b, ch);
    }
    char[] a = text.toCharArray();
    System.arraycopy(a, 0, b, 0, a.length);
    String c = new String(b);
    java.util.Arrays.fill(b, 0, a.length, ch);
    return c;
  }
}

class Padder_godfat_buf extends Padder{
  private char[] buffer = new char[0];
  public String pad(String str, char ch, int size){
    if(buffer.length < size) buffer = new char[size];
    if(size <= str.length()) return str;

    System.arraycopy(str.toCharArray(), 0, buffer, 0, str.length());
    java.util.Arrays.fill(buffer, str.length(), size, ch);
    return new String(buffer);
  }
}

public final class Padding{
  public static void main(String[] args){
    System.out.println("Padder_silver8250: " + Long.toString(benchmark(new Padder_silver8250())) + " ms.");
    System.out.println("Padder_godfat_fill: " + Long.toString(benchmark(new Padder_godfat_fill())) + " ms.");
    System.out.println("Padder_infinitlee: " + Long.toString(benchmark(new Padder_infinitlee())) + " ms.");
    System.out.println("Padder_godfat_pre: " + Long.toString(benchmark(new Padder_godfat_pre())) + " ms.");
    System.out.println("Padder_pao0111: " + Long.toString(benchmark(new Padder_pao0111())) + " ms.");
    System.out.println("Padder_godfat_buf: " + Long.toString(benchmark(new Padder_godfat_buf())) + " ms.");
  }
  private static long benchmark(Padder padder){
    long start = System.currentTimeMillis();

    for(int i=0; i<500000; ++i)
      padder.pad_spaces("abc", 50);
    for(int i=0; i<500000; ++i)
      padder.pad_spaces("abc", (int)(Math.random()*100));
    for(int i=0; i<500000; ++i)
      padder.pad_spaces("012345678901234567890123456789012345678901234567890123456789", (int)(Math.random()*100)+20);
    for(int i=0; i<500000; ++i)
      padder.pad_spaces("012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789", (int)(Math.random()*100)+50);

    return System.currentTimeMillis() - start;
  }
}
