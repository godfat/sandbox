
#include "export.hpp"
#include <iostream>

template <class T>
void f(){ std::cout << typeid(T).name() << std::endl; }
