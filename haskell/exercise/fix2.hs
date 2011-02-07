
module Main where

sieve :: Int -> [Int] -> [Int]
sieve n xs = filter (\x -> (mod x n) /= 0) xs

fix2 :: [Int] -> [Int]
fix2 [] = []
fix2 (x:xs) = x : fix2 (sieve x xs)

main = print (fix2 [2..] !! 2000)
