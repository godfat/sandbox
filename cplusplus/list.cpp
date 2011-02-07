
#include <iostream>
#include <iterator>
#include <list>
#include <algorithm>
#include <cstddef>

using std::list;
using std::size_t; // usually is unsigned int

template <class T, size_t N>
struct List: public list<T>{
  List(): list<T>(N){} // for size N list
  List(T t[N]): list<T>(t, t+N){} // init up the data
};

template <class T, size_t N> // simulate head
T head(List<T, N> const& xs){
  return xs.front();
}

template <class T, size_t N> // simulate tail
List<T, N-1> tail(List<T, N> const& xs){
  List<T, N-1> result;
  copy(++xs.begin(), xs.end(), result.begin());
  return result;
}

// it could be so complex if List is constructed like a tuple,
// so here i just make it be an array like stuff,
// copy the data through list iterator
template <class T, size_t N>
List<T, N+1> cons(T const& x, List<T, N> const& xs){
  List<T, N+1> result;
  copy(xs.begin(), xs.end(), ++result.begin());
  result.front() = x;
  return result;
}

// then here we do the normal append
// and it's too hard to simulate pattern matching...
// so just do it with head and tail
template <class T, size_t N, size_t M>
List<T, N+M> append(List<T, N> const& xs, List<T, M> const& ys){
  return cons(head(xs), append(tail(xs), ys));
}

// if the size of xs is zero, then just return ys
template <class T, size_t M>
List<T, M> append(List<T, 0> const& xs, List<T, M> const& ys){
  return ys;
}

template <class T, size_t N, size_t M>
List<T, N+M> revcat(List<T, N> const& xs, List<T, M> const& ys){
  return revcat(tail(xs), cons(head(xs), ys));
}

template <class T, size_t M>
List<T, M> revcat(List<T, 0> const& xs, List<T, M> const& ys){
  return ys;
}

int main(){
  int tmpa[3] = {0,1,2};
  int tmpb[3] = {3,4,5};
  List<int, 3> a(tmpa); // there would be better way to init it in C++0x
  List<int, 3> b(tmpb);

  List<int, 6> c = append(a, b);
  List<int, 9> d = revcat(c, a);

  // output magic through ostream_iterator,
  // it would output each element in c, separated by " "
  copy(d.begin(), d.end(), std::ostream_iterator<int>(std::cout, " "));
  std::cout << std::endl;
}
