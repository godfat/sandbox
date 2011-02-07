
#include <typeinfo>
#include <iostream>
#include <ctime>

int main(){
    std::cout << typeid(int).name() << std::endl;
    std::cout << typeid(std::time_t).name() << std::endl;
    std::cout << typeid(long).name() << std::endl;
    std::cout << typeid(int unsigned).name() << std::endl;
    std::cout << typeid(10u - 5u).name() << std::endl;

    std::cout << sizeof(int) << std::endl;
    std::cout << sizeof(long) << std::endl;
    std::cout << sizeof(long long) << std::endl;
    std::cout << sizeof(void*) << std::endl;
}
