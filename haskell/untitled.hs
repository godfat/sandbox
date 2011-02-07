
-- kind Nat = Z | S Nat

data List :: *0 ~> Nat ~> *0 where
  Nil :: List a Z
  Cons :: a -> List a n -> List a (S n)

--

plus :: Nat ~> Nat ~> Nat
{plus Z y} = y
{plus (S x) y} = S {plus x y}

plusA :: Nat' n -> Equal {plus n (S m)} (S {plus n m})
plusA Z = Eq
plusA (S x) = Eq where theorem plusAA = plusA x

plusZ :: Nat' n -> Equal {plus n Z} n
plusZ Z = Eq
plusZ (S x) = Eq where theorem plusZZ = plusZ x

--

append :: List a n -> List a m -> List a {plus n m}
append Nil ys = ys
append (Cons x xs) ys = Cons x (append xs ys)

--

revcat :: List a n -> List a m -> List a {plus n m}
revcat Nil ys = ys
revcat (Cons x xs) ys = revcat xs (Cons x ys) where theorem plusA

--

merge :: List Int n -> List Int m -> List Int {plus n m}
merge xs Nil = xs where theorem plusZ
merge Nil ys = ys
merge (Cons x xs) (Cons y ys) =
   if x <= y then Cons x (merge xs (Cons y ys))
   else Cons y (merge (Cons x xs) ys) where theorem plusA

--

test1 = Cons 1 Nil
test2 = append test1 (Cons 2 Nil)
test3 = append (Cons 0 Nil) test2
test4 = merge test3 test3
test5 = merge test3 Nil

--

data Sum  :: Nat ~> Nat ~> Nat ~> *0 where
  SumBase :: Sum Z n n
  SumStep :: Sum n m s -> Sum (S n) m (S s)

data Ans a n m = exist s . Ans (List a s) (Sum n m s)

append2 :: List a n -> List a m -> Ans a n m
append2 Nil ys = Ans ys SumBase
append2 (Cons x xs) ys = Ans (Cons x zs) (SumStep s) where
  (Ans zs s) = append2 xs ys

--

test6 = append2 test3 test3

--
