
{-
Problem 3 http://projecteuler.net/index.php?section=problems&id=3
02 November 2001

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?
-}

primes :: [Int]
primes = 2 : 3 : sieve [5, 7..]
  where sieve (x:xs) = x : sieve [y | y <- xs, y `mod` x /= 0]

----------------------------------------------------------------------

faster_primes :: [Int]
faster_primes = 2 : 3 : sieve (tail faster_primes) [5, 7..]
  where sieve (p:ps) xs = h ++ sieve ps [x | x <- t, rem x p /= 0]
                                    -- or:  filter ((/=0).(`rem`p)) t
                          where (h,t) = span (< p*p) xs

----------------------------------------------------------------------

prime_factors :: Int -> [Int] -> [Int]
prime_factors n ps =
  snd (foldr repeat_factors (n, []) (takeWhile (<m) ps)) where
    m = floor (sqrt (fromIntegral n))

repeat_factors :: Int -> (Int, [Int]) -> (Int, [Int])
repeat_factors i (m, r)
  | m         == 1 = (m, r)
  | m `mod` i == 0 = repeat_factors i (m `div` i, i : r)
  | otherwise      = (m, r)

----------------------------------------------------------------------

main = putStrLn . show $ prime_factors 600851475143 faster_primes
