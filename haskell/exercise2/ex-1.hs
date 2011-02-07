{-- 1 --}
data Tree a = Tip a | Bin (Tree a)(Tree a)
flatten :: Tree a -> [a]
flatten (Tip a) = [a]
flatten (Bin x y) = (flatten x) ++ (flatten y)

{-- 2 --}
   {--
   因為有 ++ , 使flatten計算複雜度為O(logN*logN)
   --}
fastflatten :: Tree a -> [a] -> [a]
   {-- derivation sequence
   fastflatten t xs = flatten t ++ xs
   base case: fastflatten (Tip x) xs
              = flatten (Tip x) ++ xs
              = [x] ++ xs
   inductive case: fastflatten (Bin x y) xs
                   = flatten (Bin x y) ++ xs
                   = flatten x ++ flatten y ++ xs
                   = flatten x ++ fastflatten y xs
                   = fastflatten x (fastflatten y xs)
   --}
fastflatten (Tip x) xs = [x] ++ xs
fastflatten (Bin x y) xs = fastflatten x (fastflatten y xs)

{-- 3 --}
factorial :: Int -> Int
factorial n = foldr (*) 1 (take n [1..])

{-- 4.1 --}
sieve1 :: Int -> [Int] -> [Int]
sieve1 n [] = []
sieve1 n (x:xs) = if x `mod` n == 0 then sieve1 n xs
                                    else [x] ++ sieve1 n xs
sieve2 :: Int -> [Int] -> [Int]
sieve2 n = foldr (\x xs -> (if x `mod` n /= 0 then [x] else []) ++ xs) []
sieve3 :: Int -> [Int] -> [Int]
sieve3 n = filter (\x -> x `mod` n /= 0)

{-- 4.2 --}
fix :: [Int] -> [Int]
fix [] = []
fix (x:xs) = x : sieve1 x (fix xs)

{-- 4.3 --}
fix2 :: [Int] -> [Int]
fix2 [] = []
fix2 (x:xs) = x : fix2 (sieve1 x xs)

   {--
   我想, fix的每一循環都處理一樣多的資料量,
   但fix2的每一循環處理篩選過而減少的資料量,
   fix2比較快.
   --}

{-- 4.4 --}
check n = zipWith (==) (take n (fix [2..])) (take n (fix2 [2..]))
