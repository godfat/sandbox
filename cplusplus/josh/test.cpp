// godfat ~/p/t/josh> g++-mp-4.4 -std=c++98 -Wall -pedantic test.cpp -o test
// godfat ~/p/t/josh> ./test
// hack
// 0
// hack
// 2

#include "getset.hpp"
#include <iostream>

using std::cout;
using std::endl;

class C: public GetSet<C>{
public:
    template <typename S>
    typename S::type const& get() const;

// protected:
    int test;
};

GENERATE_SELECTOR(C, int, C::test, N);

template <typename S>
typename S::type const& C::get() const{
    cout << "hack" << endl;
    return GetSet<C>::get<N>();
}

int main(){
    C c;

    c.set<N>(0);
    cout << c.get<N>() << endl;

    c.set<N>(2);
    cout << c.get<N>() << endl;
}
