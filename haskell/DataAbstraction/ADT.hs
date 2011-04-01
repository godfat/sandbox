
module ADT(Set) where

class Set set where
  empty    :: set
  insert   :: set -> Int -> set
  union    :: set -> set -> set
  contains :: set -> Int -> Bool

data SetImp = Empty               |
              Insert SetImp Int   |
              Union  SetImp SetImp deriving Show

instance Set SetImp where
  empty                         = Empty
  insert                        = Insert
  union                         = Union
  contains  Empty             _ = False
  contains (Insert set     x) y = if x == y then
                                    True
                                  else
                                    contains set y

  contains (Union  set0 set1) y = if contains set0 y then
                                    True
                                  else
                                    contains set1 y

a, b, c :: (Set set) => set
a = empty
b = insert a 1
c = union b a

d, e :: Bool
d = contains (c::SetImp) 1
e = contains (c::SetImp) 2
