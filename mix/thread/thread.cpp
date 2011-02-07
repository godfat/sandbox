
#include <boost/thread.hpp>
#include <tr1/memory>
#include <iostream>

using namespace boost;
using namespace std;

struct data{
    data(int i){ this->i = i; }
    ~data(){
        cout << "bye " << endl;
    }
    int i;
};

typedef shared_ptr<data> pint;

struct f{
    f(pint p){
        p_ = p;
    }
    void operator()(){
        cout << p_->i << endl;
        p_.reset();
        cout << "XD" << endl;
        // thread::sleep(posix_time::from_time_t(time(0) + 2));
    }
    pint p_;
};

int main(){
    pint p1(new data(5));
    thread t1 = thread(f(p1));
    thread t2 = thread(f(p1));
    p1.reset();

    t1.join();
    t2.join();
}
