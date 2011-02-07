
fibs :: [Int]
fibs = 0 : 1 : [ a + b | (a, b) <- zip fibs (tail fibs)]

fib :: [Int]
fib = 0 : 1 : zipWith (+) fib (tail fib)

fibs2 = 0 : 1 : (map (\x -> fst x + snd x) (zip fibs2 (tail fibs2)))
