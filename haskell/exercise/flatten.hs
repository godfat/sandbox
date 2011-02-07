
module Flatten where
{-
1. Given the datatype definition:

     data Tree a = Tip a
                 | Bin (Tree a) (Tree a)

   Define

      flatten :: Tree a -> [a]

   that returns the tips of the tree from left
   to right.
-}
data Tree a = Tip a
            | Bin (Tree a) (Tree a) deriving Show

flatten :: Tree a -> [a]
flatten (Tip a) = [a]
flatten (Bin a b) = flatten a ++ flatten b

test_tree1 = Bin (Bin (Tip 1) (Tip 2)) (Bin (Tip 3) (Tip 4))
test_tree2 = Bin (Bin (Tip 1) (Bin (Tip 2) (Tip 3))) (Bin (Tip 4) (Tip 5))

{-
2. What is the time complexity of the function
   flatten you have defined?

   If it is not linear, can you derive a linear
   variant of flatten, starting from this
   definition:

      fastflatten :: Tree a -> [a] -> [a]
      fastflatten t xs = flatten ? ? ?
          = ...?
-}

-- linear i guess? or with ++ so not linear?
-- i am not familiar with algorithm...

fastflatten :: Tree a -> [a] -> [a]
fastflatten (Tip a        ) xs = a : xs
-- fastflatten (Bin a (Tip b)) xs = fastflatten a (b:xs)
fastflatten (Bin a b      ) xs = fastflatten a (fastflatten b xs)

{-
3. Well, let's practice using some library functions...

   Recall that [1..] creates an infinite list starting
   from 1.

   Define factorial using [1..], take, and foldr
   (thus you do not need recursion).
-}

factorial :: Int -> Int
factorial n = foldr (*) 1 (take n [1..])

{-
4.1 Define a function

      sieve :: Int -> [Int] -> [Int]

    such that sieve n xs removes elements in xs that
    are multiples of n.

    You may either use recursion, use a foldr, or
    use the library function filter. You will also
    need the built-in function "mod".
-}

-- filter
sieve :: Int -> [Int] -> [Int]
sieve n xs = filter (\x -> (mod x n) /= 0) xs

-- no lambda expression
sieve2 :: Int -> [Int] -> [Int]
sieve2 n = filter $ (/=0).(flip mod n)

-- list comprehension
sieve3 :: Int -> [Int] -> [Int]
sieve3 n xs = [y | y <- xs, mod y n /= 0]

-- recursive case of
sieve4 :: Int -> [Int] -> [Int]
sieve4 n [] = []
sieve4 n (x:xs) = let
                    rest = sieve5 n xs
                  in
                    case mod x n of
                        0 -> rest
                        _ -> x : rest

-- foldr with lambda expression
sieve5 :: Int -> [Int] -> [Int]
sieve5 n = foldr (\x rest -> if mod x n /= 0 then
                                x : rest
                             else
                                rest) []

{-
4.2 Having sieve, define:

      fix (x:xs) = x : sieve x (fix xs)

    What does fix [2..] represent? In the GHCi or
    Hugs interpreter, how do you examine the first 100
    outputs of fix [2..]?
-}

-- prime number list? just use take or !! to examine.

fix :: [Int] -> [Int]
fix [] = []
fix (x:xs) = x : sieve x (fix xs)

{-
4.3 What about

      fix2 (x:xs) = x : fix2 (sieve x xs)

    What does it represent? Which of fix and fix2 is
    faster? Why?
-}

-- on my benchmark, fix2 is extremely faster than fix...
-- dunno why, perhaps tail recursion?

fix2 :: [Int] -> [Int]
fix2 [] = []
fix2 (x:xs) = x : fix2 (sieve x xs)

{-
4.4 In the interpreter, check whether fix [2..] and
    fix2 [2..] yield the same output for the first
    100, 200, or 300 outputs. You may find some standard
    library function such as zipWith, (==), take, and
    "and" useful.

    ("and" is a function having type [Bool] -> Bool.
     You can easily guess what it does...)
-}

-- it always returns True.

fix_test n = and $ zipWith (==) (take n (fix [2..])) (take n (fix2 [2..]))
fix_test2 n = and $ take n $ map (\(x,y) -> x == y) [(x,y) | (x,y) <- zip (fix [2..]) (fix2 [2..])]
