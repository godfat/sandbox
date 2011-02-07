
#include <iostream>
#include <map>
#include <boost/function.hpp>

void f(){}

int main(){
  std::map<int, boost::function<void()> > m;
  // m[10] = f;
  std::cout << (m[10] == NULL) << std::endl;
}
