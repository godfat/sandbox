
#include <iostream>

template <class T> class B;

template <class T>
class A{
friend class B<T>;
public:
    A(): i(123){}
private:
    int i;
};

template <class T>
class B{
public:
    int f(){ return a.i; }
private:
    A<T> a;
};

int main(){
    std::cout << B<int>().f() << std::endl;
}
