module Jai where

-- ---exercise 1.---

data Tree a = Tip a
            | Bin (Tree a) (Tree a)

flatten :: Tree a -> [a]
flatten (Tip t) = [t]
flatten (Bin l r) = (flatten l) ++ (flatten r)

-- ---exercise 2.---

{-

fastflatten t xs = (flatten t) ++ xs

Base Case
  (flatten (Tip t)) ++ xs
= {definition of flatten}
  ([t] ++ xs)
= { ? }
  (t : xs)

Inductive Case
  (flatten (Bin l r)) ++ xs 
= {definition of flatten}
  ((flatten l) ++ (flastten r)) ++ xs
= {since (a++b)++c = a++(b++c)}
  (flatten l) ++ ((flatten r) ++ xs)
= {definition of fastflatten}
  (flatten l) ++ (fastflatten r xs)
= {definition of fastflatten}
  (fastflatten l (fastflatten r xs))

-}

fastflatten :: Tree a -> [a] -> [a]
fastflatten (Tip t) xs = t : xs
fastflatten (Bin l r) xs =  fastflatten l (fastflatten r xs)

-- ---exercise 3.---

fact :: Int -> Int
fact n = foldr (*) 1 (take n [1..])

-- ---exercise 4.1.---

sieve :: Int -> [Int] -> [Int]
sieve n = foldr foo [] 
  where foo x xs
          | (mod x n) == 0 = xs
          | otherwise = x : xs  

-- -- recursion version
-- sieve n [] = []
-- sieve n (x:xs) 
--   | (mod x n) == 0 = (sieve n xs)
--   | otherwise = x : (sieve n xs)

-- ---exercise 4.2.---

fix :: [Int] -> [Int]
fix [] = []
fix (x:xs) = x : sieve x (fix xs)
-- fix [2..] = all prime number.
-- how do I examine? 
-- maybe "take 100 (fix [2..])" :p

prime = \n -> take n (fix [2..])

-- ---exercise 4.3.---

fix2 :: [Int] -> [Int]
fix2 [] = []
fix2 (x:xs) = x : fix2 (sieve x xs)

-- fix [2..] = 2 : sieve 2 (fix [3..])
--           = 2 : sieve 2 (3 : (sieve 3 (fix [4..])))
--           = ...
-- fix2 [2..] = 2 : fix2 (sieve 2 [3..])
--            = 2 : fix2 [3,5..]
--            = ...
-- fix2 is faster than fix.


-- ---exercise 4.4.---

test = \n -> and (take n (zipWith (==) (fix [2..]) (fix2 [2..])))





