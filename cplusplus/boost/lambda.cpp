
#include <boost/lambda/lambda.hpp>
#include <boost/lambda/loops.hpp>
#include <iostream>
#include <vector>
#include <iterator>
#include <algorithm>

struct back_inserter{
  typedef back_inserter element_type;
  back_inserter(std::vector<int> &v): v_(v){}
  back_inserter& operator*(){ return *this; }
  back_inserter& operator=(int i){ v_.push_back(i); return *this; }
private:
  std::vector<int>& v_;
};

int main(){
  using boost::lambda::var;
  using boost::lambda::_1;
  
  std::vector<int> v;
  // int *ii;
  {
    int i;
    back_inserter b(v);
    boost::lambda::for_(var(i)=0, var(i)<10, ++var(i))
      [*_1 = var(i)]
      (b);
  }

  std::for_each(v.begin(), v.end(), std::cout << _1 << " ");
  std::cout << std::endl;
}
