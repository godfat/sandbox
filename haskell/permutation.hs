
import Data.List (delete, nub)

combos :: [[a]] -> [[a]]
combos []       = [[]]
combos (xs:xss) = do
  x  <- xs
  ys <- combos xss
  return (x:ys)

-- p :: Eq a => [a] -> [[a]]
-- p [] = [[]]
-- p xs = do
--   x  <- xs
--   ys <- p (delete x xs)
--   return (x:ys)

p' :: Eq a => [a] -> Int -> [[a]]
p' [] _ = [[]]
p' xs n = do
  x  <- xs
  ys <- p' (delete x xs) n -- we can't use delete, consider abbc,
                           -- we might take the latter b, but delete
                           -- the former b!
  return (take n (x:ys))

p :: Eq a => [a] -> Int -> [[a]]
p = curry (nub . (uncurry p'))

--

split :: [a] -> [a] -> [(a, [a])]
split [] _ = []
split (x:xs) ys = (x, reverse ys++xs) : split xs (x:ys)

permutation :: Eq a => [a] -> [[a]]
permutation [] = [[]]
permutation xs = do
  (y, ys) <- split xs []
  zs      <- permutation ys
  return (y:zs)
