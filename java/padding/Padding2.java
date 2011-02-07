
// original post silver8250
public final class Padding2{
  public static void main(String[] args){
    for(int i=0; i<1000000; ++i)
      padding("abc", 50);
  }
  private static String padding(String data, int size){
    int length = data.getBytes().length; //因為中文英文的長度不同
    StringBuffer sb = new StringBuffer(data);
    for (int i=0 , n=size-length ; i<n ; i++) {
      sb.append(" ");
    }
    return sb.toString();
  }
}
