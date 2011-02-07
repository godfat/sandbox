
module Main where

import Data.List (unfoldr, intercalate)

candidates :: Int -> [Int]
candidates n = unfoldr (\x -> if (head x)^2 <= n then
                                Just (head x, tail x)
                              else
                                Nothing) [0..]

answers :: Int -> [(Int, Int)]
answers n = [(x, y) |
               x <- candidates n,
               y <- filter (<x) (candidates n),
               x /= y,
               x^2 + y^2 == n]

solve :: String -> [Int]
solve str = map (length . answers . read) (lines str)

to_str :: [Int] -> String
to_str = (intercalate "\n") . map show

main = do
  putStr "test"
  getLine
  str <- getContents
  putStrLn (to_str (solve str))
