
module Prob (Prob, join) where

import Data.Ratio (Rational, (%))
import Data.List (groupBy, sortBy, find)

import Control.Applicative (Applicative, pure, (<$>), (<*>))
import Control.Monad ((<=<))

import Test.QuickCheck (quickCheck)
import Test.QuickCheck.Arbitrary (Arbitrary, arbitrary)
import Test.QuickCheck.Function -- why can't i import only for Fun?

newtype Prob a = Prob { getProb :: [(a, Rational)] } deriving (Show, Eq)

instance Functor Prob where
  fmap f (Prob prob) = Prob $ map (\(x, p) -> (f x, p)) prob

instance Applicative Prob where
  pure a = Prob [(a, 1)]
  apps <*> prob = do
    f <- apps
    p <- prob
    return (f p)

instance Monad Prob where
  return = pure
  p >>= f = join (fmap f p)

join :: Prob (Prob a) -> Prob a
join (Prob prob) = Prob $ concat $ map
  (\((Prob prob'), p) -> map (\(x, p') -> (x, p * p')) prob') prob

----------------------------------------------------------------------------

coin :: Prob Bool
coin = Prob [(True, 1%2), (False, 1%2)]

collapse :: (Eq a, Ord a) => Prob a -> Prob a
collapse (Prob prob) =
  Prob $ (concat . group . sort) prob where
    sort   =  sortBy (\x y -> compare (fst x) (fst y))
    group  = groupBy (\x y -> fst x == fst y)
    concat = map (foldr1 (\(x, p) (_, p') -> (x, p + p')))

----------------------------------------------------------------------------

functorLawId :: Eq a => Prob a -> Bool
functorLawId prob = fmap id prob == id prob

functorLawComposition :: Eq c => Fun b c -> Fun a b -> Prob a -> Bool
functorLawComposition (Fun _ f) (Fun _ g) prob =
  fmap (f . g) prob == (fmap f . fmap g) prob

----------------------------------------------------------------------------

monadLawId :: Eq b => Fun a b -> a -> Bool
monadLawId (Fun _ f) x =
  ((return :: b -> Prob b) . f) x == (fmap f . return) x

monadLawLeftId :: Eq b => Fun a (Prob b) -> a -> Bool
monadLawLeftId (Fun _ f) x = ((return x) >>= f) == f x

monadLawRightId :: Eq a => Prob a -> Bool
monadLawRightId prob = (prob >>= return) == prob

monadLawAssociativity :: Eq d =>
                         Fun c (Prob d) ->
                         Fun b (Prob c) ->
                         Fun a (Prob b) -> a -> Bool

monadLawAssociativity (Fun _ f) (Fun _ g) (Fun _ h) x =
  ((f <=< g) <=< h) x == (f <=< (g <=< h)) x

----------------------------------------------------------------------------

instance Arbitrary a => Arbitrary (Prob a) where
  arbitrary = fmap Prob arbitrary

----------------------------------------------------------------------------

main = do
  quickCheck (functorLawId :: Prob  Int -> Bool)
  quickCheck (functorLawId :: Prob Bool -> Bool)
  quickCheck (functorLawComposition ::
                Fun Char Int -> Fun Bool Char -> Prob Bool -> Bool)
  quickCheck (monadLawId :: Fun Int Char -> Int -> Bool)
  quickCheck (monadLawLeftId :: Fun Bool (Prob Int) -> Bool -> Bool)
  quickCheck (monadLawRightId :: Prob Int -> Bool)
  quickCheck (monadLawAssociativity :: Fun Char (Prob Int) ->
                                       Fun Bool (Prob Char) ->
                                       Fun String (Prob Bool) ->
                                       String -> Bool)

-- what's the probability for throwing two coins and they are all True?
test :: Rational
test = case maybe of
         Just (_, p) -> p
         Nothing     -> 0
         where maybe = find fst $ getProb $ collapse $
                         (sequence [coin, coin]) >>= (return . and)
