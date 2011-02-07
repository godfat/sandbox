
module Main where

sieve :: Int -> [Int] -> [Int]
sieve n xs = filter (\x -> (mod x n) /= 0) xs

fix :: [Int] -> [Int]
fix [] = []
fix (x:xs) = x : sieve x (fix xs)

main = print (fix [2..] !! 2000)
