#include <stdio.h>
int main(){
  int x = 1;
  int a(){
      int b(){
          x = 2;
      }
      b();
  }
  a();
  printf("%d\n", x);
  return 0;
}
