
#include <iostream>
#include <vector>
#include <cstddef>

// template <class T, template <class, class> class C>
// struct ArrayImp: public C< T, std::allocator<T> >{
//     explicit ArrayImp(std::size_t size = 0): C< T, std::allocator<T> >(size){}
// };

template <class T, int Dim,
    template <class, class> class C = std::vector>
struct Array: public C<Array<T, Dim-1, C>, std::allocator<Array<T, Dim-1, C> > >{
    explicit Array(std::size_t size = 0):
        C<Array<T, Dim-1, C>, std::allocator<Array<T, Dim-1, C> > >(size){}
};

template <class T, template<class, class> class C>
struct Array<T, 1, C>: public C<T, std::allocator<T> >{
    explicit Array(std::size_t size = 0):
        C<T, std::allocator<T> >(size){}
};

int main(){
    Array<int, 3> array(1);
    std::cout<< array[0].size() << std::endl;
    // array.push_back(Array<int, 2>());
    // array[0].push_back(Array<int, 1>());
    // array[0][0][0] = 10;
    // std::cout << array[0][0][0] << std::endl;
}
