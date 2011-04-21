
collatz :: Int -> Int
collatz = collatz' 1

collatz' :: Int -> Int -> Int
collatz' step n | n == 1 = step
                | even n = collatz' (step+1) (n `div` 2)
                |  odd n = collatz' (step+1) (n * 3 + 1)

result = do
  i <- [1..10000]
  "L[" ++ show i ++ "] = " ++ show (collatz i) ++ "\n"

main = putStr result
