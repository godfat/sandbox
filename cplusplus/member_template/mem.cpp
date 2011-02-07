
template <class T>
class C{
  template <class U>
  void f();
};

template <class T>
template <>
void C<T>::f<int>();
