module reason where

open import Data.Nat
open import Data.List
open import Relation.Binary.PropositionalEquality
-- import Relation.Binary.EqReasoning as Eq

square : ℕ -> ℕ
square n = n * n

foldr' : {a b : Set} -> (a -> b -> b) -> b -> List a -> b
foldr' c n []       = n
foldr' c n (x ∷ xs) = c x (foldr' c n xs)

sum' : List ℕ -> ℕ
sum' = foldr' _+_ 0

sumsq₁ : List ℕ -> ℕ
sumsq₁ xs = sum' (map square xs)

sumsq₂ : List ℕ -> ℕ
sumsq₂ [] = 0
sumsq₂ (x ∷ xs) = (square x) + (sumsq₂ xs)

lemma₁ : (xs : List ℕ) -> sumsq₁ xs ≡ sumsq₂ xs
lemma₁ [] = ≡-refl
lemma₁ (x ∷ xs) = begin
       sumsq₁ (x ∷ xs)
         ≡⟨ byDef ⟩
       sum' (map square (x ∷ xs))
         ≡⟨ byDef ⟩
       sum' ((square x) ∷ map square xs)
         ≡⟨ byDef ⟩
       (square x) + sum' (map square xs)
         ≡⟨ byDef ⟩
       (square x) + (sumsq₁ xs)
         ≡⟨ ≡-cong (_+_ (square x)) (lemma₁ xs) ⟩
       (square x) + (sumsq₂ xs)
       ∎
  where
  open ≡-Reasoning
