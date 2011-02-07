
#include <boost/lambda/lambda.hpp>
#include <iostream>
#include <vector>
#include <algorithm>

using std::cout;
using std::endl;
using std::vector;
using std::for_each;
using boost::lambda::_1;

template <class C, class F>
void for_all(C& c, F f){
  for_each(c.begin(), c.end(), f);
}

int main(){

  vector<int> v(10);
  for_all(v, _1 = 3);
  for_all(v, cout << _1);

}
