
import Data.List

q1 :: String -> String
q1 = intercalate " " . map reverse . words

q2 :: Int -> [Int]
q2 n = [ x | x <- [1..n], x `mod` 3 /= 0, all (/='3') (show x) ]
