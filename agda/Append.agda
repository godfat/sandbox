module Main where

open import Data.Nat
open import Data.List hiding (foldr; length)

-- Fold on lists, with dependent type.

foldr : {a : Set} -> (b : List a -> Set) -> ({xs : List a} -> (x : a) -> b xs -> b (x :: xs)) -> b [] ->
        (xs : List a) -> b xs
foldr b f e [] = e
foldr b f e (x :: xs) = f x (foldr b f e xs)

-- ordinary append

append : {a : Set} -> List a -> List a -> List a
append {a} xs ys = foldr (\_ -> List a) (\z zs -> z :: zs) ys xs

-- ListLen xs n is a proof that the list xs has length n

data ListLen {a : Set} : List a -> Nat -> Set where
  NilZero  : ListLen [] 0
  ConsSucc : {xs : List a} {n : Nat} {x : a} -> ListLen xs n -> ListLen (x :: xs) (1 + n)

length : {a : Set} -> List a -> Nat
length [] = 0
length (x :: xs) = 1 + length xs

{--

 I would like appendlen to have type

    appendlen : {a : Set} {m n : Nat} ->
         (xs : List a, Listlen xs m) -> (ys : List a, Listlen ys m) ->
           (zs : List a, Listlen zs (m + n))

However, (xs : List a, Listlen xs m) is not a Cartesian product.
It is what people call a "dependent pair" or a "dependent sum."

The type Pair a b, defined below, represents (xs : a, b a).
--}

data Pair (a : Set) (b : a -> Set) : Set where
  pair : (x : a) -> b x -> Pair a b

ListWithLen : Set -> Nat -> Set
ListWithLen a n = Pair (List a) (\ xs -> ListLen xs n)

appendlen : {a : Set} {m n : Nat} -> ListWithLen a m -> ListWithLen a n -> ListWithLen a (m + n)
appendlen = {! !}

