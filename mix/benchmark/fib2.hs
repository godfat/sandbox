
module Fib2 where

fibs = 0 : 1 : [ x + y | (x, y) <- zip fibs (tail fibs)]

fib :: Int -> Int
fib n = fib' id n where
        fib' f n | n < 2 = f n
        fib' f n = fib' (\v -> fib' (\m -> v + f m) (n-2)) (n-1)

--

mydrop :: Int -> [a] -> [a]
mydrop 0 xs = xs
mydrop (n+1) (x:xs) = mydrop n xs
