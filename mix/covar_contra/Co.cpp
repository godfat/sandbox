
#include <iostream>
using std::cout;
using std::endl;

class Mutant;
class Human{
public:
    virtual Human* touch(Mutant* m){
        cout << "Human" << endl;
        return this;
    }
};

class Mutant: public Human{
public:
    virtual Mutant* touch(Human* h){
        cout << "Mutant" << endl;
        return this;
    }
};

int main(){
    Mutant m;
    Human* h = &m;
    h->touch(&m);
}
