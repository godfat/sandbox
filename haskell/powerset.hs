
module Powerset where

powerset :: [a] -> [[a]]
powerset     [] = [[]]
powerset (x:xs) = concat $ map (powerset') [True, False] where
  -- powerset' :: Bool -> [[a]]
  powerset' flg = map (\ys -> if flg then x:ys else ys) (powerset xs)
