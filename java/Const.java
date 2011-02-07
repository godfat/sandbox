
class Const{
    public static void main(String[] args){
        String s1 = "123";
        String s2 = new String("123");
        System.out.println(is_const(s1));
        System.out.println(is_const(s2));
    }
    private static boolean is_const(String s){
        String ss = "123";
        return ss == s;
    }
}
