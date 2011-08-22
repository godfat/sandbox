
{-
Problem 52 http://projecteuler.net/index.php?section=problems&id=52
12 September 2003

It can be seen that the number, 125874, and its double, 251748, contain exactly the same digits, but in a different order.

Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x, contain the same digits.
-}

import Data.List (find, sort)

inf :: [Int]
inf = [1..]

answer :: Int -> Bool
answer x =
  all (==digits) (map (\n -> sort (show (x * n))) [2..6])
  where
    digits = sort (show x)

main = do
  case find answer inf of
    Nothing -> putStrLn "404 Not Found"
    Just x  -> print x
