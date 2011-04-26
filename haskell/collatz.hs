
import Data.Map as Map
import Data.List (intercalate)

limit = 50000



--         6.52 real         1.70 user         0.33 sys
collatz :: Int -> Int
collatz = collatz' 1

collatz' :: Int -> Int -> Int
collatz'    _ 0          = 0
collatz' step n | n == 1 = step
                | even n = collatz' (step+1) (n `div` 2)
                |  odd n = collatz' (step+1) (n * 3 + 1)

result = do
  i <- [1..limit]
  "L[" ++ show i ++ "] = " ++ show (collatz i) ++ "\n"

main = putStr result

----------------------------------------------------------------

-- hang at L[9663]
collatz'coinductive :: [Int]
collatz'coinductive = 1:[(collatz'coinductive !! ((next n)-1))+1 | n<-[2..]]
  where next n = if even n then n `div` 2 else n * 3 + 1

--result = foldr (\(i, v) r -> "L[" ++ show i ++ "] = " ++ show v ++ "\n" ++ r)
--  ""
--  (zip [1..limit] collatz'coinductive)

--main = putStr result

----------------------------------------------------------------

--         7.28 real         2.43 user         0.42 sys
collatz'cache :: Int -> Int
collatz'cache n = Map.findWithDefault (-1) n collatz'cache'

collatz'cache' :: Map Int Int
collatz'cache' =
  foldr
    (\k m -> Map.insert k (1+(Map.findWithDefault (fallback k) (next k) m)) m)
    Map.empty
    [0..limit] where

  fallback n = if n <= 1 then n-1 else collatz (next n)
  next     n = if even n then n `div` 2 else n * 3 + 1

--result = do
--  i <- [1..limit]
--  "L[" ++ show i ++ "] = " ++ show (collatz'cache i) ++ "\n"

--main = putStr result

----------------------------------------------------------------

--result [] [] = return ()
--result (i:is) (x:xs) = do
--  putStrLn $ "L[" ++ show i ++ "] = " ++ show x
--  result is xs

--main = do
--  result input (map collatz input) where input = [1..limit]
