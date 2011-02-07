// author:
// http://joshkos.blogspot.com/2009/06/blog-post_13.html

#ifndef GETSET_HPP
#define GETSET_HPP

template<typename T, typename C, T C::* P>
struct Selector {  // used for selecting which field to access
  static T C::* const MP;
  typedef T Type;
};

template<typename T, typename C, T C::* P>
T C::* const Selector<T, C, P>::MP = P;

template<typename Derived>  // Curiously Recurring Template Pattern
class GetSet {              // ref. <<C++ Templates: the Complete Guide>>,
                            //      <<C++ Template Metaprogramming>>
public:
  template<typename S>
  const typename S::Type& get() const {
    return static_cast<const Derived* const>(this)->*S::MP;
  }

  template<typename S>
  void set(const typename S::Type& value){
    static_cast<Derived* const>(this)->*S::MP = value;
  }
};
// make defining selectors easier
#define GENERATE_SELECTOR(C,T,P,N) typedef Selector< T , C , & C :: P > N
#endif
