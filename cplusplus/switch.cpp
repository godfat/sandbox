
#include <iostream>
using std::cout;
using std::endl;

// void print_case(int i, int origi, int step){
//     switch(step){
//         case 0:
//             switch(i){
//                 case 0: cout << 'E' << endl; break;
//                 default: print_case(i, origi, step+1);
//             }
//             break;
//         case 1:
//             switch(i){
//                 case 9: cout << 'D' << endl; break;
//                 case 10: print_case(origi, origi, step+1);
//                 default: print_case(i+1, origi, step);
//             }
//     }
// }
// 
// void print_case(int i){
//     print_case(i, i, 0);
// }

void print_case(int i){
    switch(i <= 0){
        case true: cout << 'E' << endl; break;
        case false:
            switch(i <= 9){
                case true: cout << 'D' << endl; break;
                case false: 
                    switch(i <= 49){
                        case true: cout << 'C' << endl; break;
                        case false:
                            switch(i <= 99){
                                case true: cout << 'B' << endl; break;
                                case false: cout << 'A' << endl; break;
                            }
                    }
            }
    }
}

int main(){
    for(int i=0; i<=100; ++i)
        print_case(i);
}
