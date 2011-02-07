
#include "export.hpp"
#include <tuple>
#include <iostream>

using std::cout;
using std::endl;
using std::tr1::tuple;
using std::tr1::get;

typedef tuple<int, int, int> test_t;

int main(){
  test_t a;
  get<0>(a) = 10;
  get<1>(a) = 15;
  get<2>(a) = 20;
  cout << get<0>(a) << " " << get<1>(a) << " " << get<2>(a) << endl;

  f<test_t>();
}
