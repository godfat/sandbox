
#include <iostream>
#include <algorithm>
#include <string>
#include <iterator>
#include <utility>
#include <map>

namespace std{
  ostream& operator<<(ostream& os, pair<string, long> const& p){
    return os << p.first << " " << p.second;
  }
}

// template <class Key, class Value>
// class BinMap{
// public:
//   typedef std::pair<Key, Value> value_type;
//   BinMap& insert(value_type& v){
//     key_.insert(v);
//     value_.insert(make_pair(v.second, v.first));
//     return *this;
//   }
// };

int main(){
  using namespace std;
  typedef multimap<string, long> mp_t;

  mp_t mp;
  mp.insert(make_pair("godfat", 0));
  mp.insert(make_pair("godfat", 1));

  copy(mp.begin(), mp.end(), ostream_iterator<pair<string, long> >(cout, "\n"));
}
