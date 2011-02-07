
module braun where

open import Logic.Base
open import Logic.Identity
open import Logic.Equivalence
open import Data.Bool
open import Data.Nat
open import Data.Nat.Properties

Parity = Bool

parity : Parity -> Nat
parity false = 0
parity true = 1


{-
mutual
  even : Nat -> Bool
  even 0 = true
  even (1+n) = odd n

  odd : Nat -> Bool
  odd 0 = false
  odd (1+n) = even n
-}

half : Nat -> Nat
half 0 = 0
half 1 = 0
half 2 = 1
half (suc (suc n)) = 1 + half n

2halfn=n : (n : Nat) -> (half n + half n) == n
2halfn=n 0 = refl
-- 2halfn=n 1 = refl
-- 2halfn=n (suc (suc n)) = 

{-
  A Braun tree is a binary tree such that, for every non-
  null node, the left subtree either has the same number
  of elements as the right subtree, or has only one more
  element. In Agda, a Braun tree can be defined by:
-}

data Braun (A : Set) : Nat -> Set where
  nul : Braun A 0
  bin : {n : Nat} -> A -> (p : Parity) ->
          Braun A (parity p + n) -> Braun A n ->
            Braun A (1 + parity p + (n + n))

{-
copy : {A : Set} -> A -> (n : Nat) -> Braun A n
copy {A} _ 0 = nul
copy {A} a (suc n) with (even n)
... | true  = half_half {n} {Braun A} (bin a false (copy {A} a (half n)) (copy {A} a (half n)))
... | false = bin a true (copy {A} a (1 + half n)) (copy {A} a (half n))
-}

{-
  such that copy a n builds a Braun tree of size n,
  all the elements being a.

  There may be many ways to define copy. You will
  certainly need some ways to divide a number by 2,
  and will have to think about what to do when the
  number is odd.

  I find the "dependent pairs" trick quite useful:
-}

data _<<_ (A : Set) (P : (A -> Set)) : Set where
  sub : (x : A) -> P x -> A << P

{-
  where sub x p : A << P denotes a pair of a value x
  of type A and a proof p that P x holds. But you may
  not need it.

  I used the following libraries:

    open import Logic.Base
    open import Logic.Identity
    open import Data.Bool
    open import Data.Nat
    open import Data.Nat.Properties

  But do not use 'div' and 'mod' in Data.Nat. Define
  your own, if you need to.
  
-}

