{-# OPTIONS -XMultiParamTypeClasses -XFlexibleInstances -XFunctionalDependencies #-}
-- -XFlexibleContexts
module VarArgs where

class Blackhole a where
  zero'  :: a
  count' :: Integer -> a

instance Blackhole Integer where
  zero'  = 0
  count' = id

instance Blackhole b => Blackhole (a -> b) where
  zero'    _ = zero'
  count' n _ = count' (n + 1)

count :: (Blackhole a) => a
count = count' 0

zero :: (Blackhole a) => a
zero = zero'

--

class GenList a r | r -> a where
  gen' :: a -> [a] -> r

instance GenList a [a] where
-- gen' = (:)
-- gen' = curry $ reverse . (uncurry (:))
  gen' x xs = reverse (x:xs)

instance GenList a b => GenList a (a -> b) where
--  gen' :: a -> [a] -> (a -> b)
  gen' x xs = (flip gen') (x:xs)

gen :: (GenList a r) => a -> r
gen = (flip gen') []

{-
  count id id
= ((count' 0) id) (:) :: Integer -> ((x -> x) -> ((y -> [y]) -> Integer))
                         ^^^^a 0    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^b id (:)
                                     ^^^^a id    ^^^^^^b (:)
                                                  ^^^^^a (:)
-}
