
#include <boost/utility.hpp>
#include <boost/type_traits.hpp>

using namespace boost;

template <class T>
struct C{
  template <class U>
  void f(U, typename enable_if<is_function<U> >::type* dummy = 0);
  void f(int);
};

void g(){
  C<int>().f(1);
}
