public class Driver {
        public static void main(String[] args) {
                long startTime = System.currentTimeMillis();
                for (int i=0; i<50000; i++) for (int j=0; j<50000; j++);
                long endTime = System.currentTimeMillis();
                System.out.println(endTime - startTime);
        }
}
