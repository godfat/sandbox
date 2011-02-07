
class Getch{
  public static void main(String[] args) throws java.io.IOException{
    byte[] buffer = new byte[1024];
    Runtime.getRuntime().exec("stty -g").getInputStream().read(buffer);
    String state = new String(buffer);
    System.out.println(state);

    Runtime.getRuntime().exec("stty raw -echo cbreak isig");
    System.out.println(System.in.read());
  }
}
