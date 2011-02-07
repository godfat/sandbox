
{-
  3
 345
34567
 345
  3
-}

module Main where

star :: Integer -> String
star max = tail $ to_s rectangle where
  rectangle :: [[String]]
  rectangle = [spaces i ++ row i | i <- [0..max-1]]
  spaces i = map (\x->" ") [0..abs (mid-i-1) - 1]
  mid   = max `div` 2 + 1
  row :: Integer -> [String]
  row n = [ show i | i <- [mid..( max+mid-2 * abs (mid-n-1) ) - 1] ]
  to_s  = foldr (\l s -> ("\n" ++ concat l ++ s)) ""

main = putStrLn $ star 5
