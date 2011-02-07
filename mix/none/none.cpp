
#include <iostream>
#include <typeinfo>

// template <class T>
// class None: public T{
// private:
//     None<T>();
// };

struct None{
    None(){ throw "can't happen"; } 
    None(const None&){}
    void what() const{ std::cout << "what??" << std::endl; }
    template <class T>
    operator T&() const{
        throw "can't happen";
        return *this;
    }
};

class Base{
public:
    virtual Base const* test() const{
        return this;
    }
};
// 
// class Derived: public Base{
// public:
//     virtual None<Base>* test(){
//         std::cout << "???" << std::endl;
//     }
// };

None undef(){}
void what(const None& none){
    // none.Base::test();
    static_cast<const Base&>(none).test();
}

class Never{
public:
    int what;
private:
    Never(){
        what = 10;
        std::cout << "???" << std::endl;
    }
    Never(Never const&){
        what = 9;
        std::cout << "???" << std::endl;
    }
};

void g(){}

Never a(){}

int main(){
    using std::cout;
    using std::endl;

    // None const& n = undef();
    // n.what();
    // std::cout << a().what << std::endl;
    None n = undef();

    // Base base;
    // Derived derived;
    // Base* b;
    // 
    // b = &base;
    // cout << "base:    " << b->test() << endl;
    // 
    // b = &derived;
    // cout << "derived: " << typeid(derived.test()).name() << endl;
}
