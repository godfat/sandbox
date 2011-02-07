
void f();
void f(int);
void f(int,int);

template <class T>
void g(T);

void h(){
  g(static_cast<void(*)(int,int)>(f));
}
