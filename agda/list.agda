module Main where

open import Data.Show
open import Data.Integer as Int
open import Data.Bool as Bool hiding (if_then_else_)

data Nat : Set where
  zero : Nat
  succ : Nat -> Nat

data List (a : Set) : Nat -> Set where
  nil  : List a zero
  cons : {n : Nat} -> a -> List a n -> List a (succ n)

plus : Nat -> Nat -> Nat
plus zero y = y
plus (succ x) y = succ (plus x y)

plus_succ : {n m : Nat} {f : Nat -> Set} -> f (plus n (succ m)) -> f (succ (plus n m))
plus_succ {zero} xs = xs
plus_succ {succ n} {m} {f} xs = plus_succ {n} {m} {f'} xs where
  f' : Nat -> Set
  f' n = f (succ n)

succ_plus : {n m : Nat} {f : Nat -> Set} -> f (succ (plus n m)) -> f (plus n (succ m))
succ_plus {zero} xs = xs
succ_plus {succ n} {m} {f} xs = succ_plus {n} {m} {f'} xs where
  f' : Nat -> Set
  f' n = f (succ n)

plus_zero : {n : Nat} {f : Nat -> Set} -> f n -> f (plus n zero)
plus_zero {zero} xs = xs
plus_zero {succ n} {f} xs = plus_zero {n} {f'} xs where
  f' : Nat -> Set
  f' n = f (succ n)

append : {a : Set} {n m : Nat} -> List a n -> List a m -> List a (plus n m)
append nil ys = ys
append (cons x xs) ys = cons x (append xs ys)

length : {a : Set} {n : Nat} -> List a n -> Nat
length {a} {n} _ = n

typeOf : {a : Set} -> a -> Set
typeOf {a} _ = a

test1 = cons (pos 1) nil
test2 = append test1 (cons (pos 2) nil)
test3 = append (cons (pos 0) nil) test2

revcat : {a : Set} {n m : Nat} -> List a n -> List a m -> List a (plus n m)
revcat nil ys = ys
revcat {a} {succ n} {m} (cons x xs) ys = plus_succ {n} {m} {List a} (revcat xs (cons x ys))

if_then_else_ : {A : Set} -> Bool -> A -> A -> A
if true  then a else _ = a
if false then _ else a = a

-- _•_ : {A B C : Set} -> (B -> C) -> (A -> B) -> (A -> C)
-- f • g = \x -> f (g x)

-- _•_ : {A B C : Set} -> (B -> C) -> (A -> B) -> (A -> C)
_•_ : {A B C : Set} -> (B -> C) -> (A -> B) -> (A -> C)
(f • g) x = f (g x)

merge : {n m : Nat} -> List Int n -> List Int m -> List Int (plus n m)
merge nil ys = ys
merge {n} {zero} xs nil = plus_zero {n} {List Int} xs
merge {succ n} {succ m} (cons x xs) (cons y ys) =
  if x ≤ y then cons x (merge xs (cons y ys))
  else succ_plus {n} {m} {\(x : Nat) -> List Int (succ x)} (cons y (merge (cons x xs) ys))
  -- else succ_plus {n} {m} {(List Int) • succ} (cons y (merge (cons x xs) ys))

test4 = merge test3 test3
test5 = merge test3 nil

data Sum : Nat -> Nat -> Nat -> Set where
  SumBase : {n : Nat} -> Sum zero n n
  SumStep : {n m s : Nat} -> Sum n m s -> Sum (succ n) m (succ s)

-- data Ans : List -> Sum -> Set where
  -- ans : {s : Nat}(a : Set)(n m : Nat) -> Ans (List a s) (Sum n m s)

-- append2 : (a : Set) (n m : Nat) -> Ans a n m

{-

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
-}
