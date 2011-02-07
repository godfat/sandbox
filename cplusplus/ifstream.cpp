
#include <iostream>
#include <fstream>

int main(){
    std::ifstream infile;
    infile.open("ifstream.txt");
    int i;
    while(infile >> i){
        std::cout << i << std::endl;
    }
}
