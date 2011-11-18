
merge :: (Ord a) => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge xss@(x:xs) yss@(y:ys) | x <  y = x : merge xs yss
                            | x == y = x : y : merge xs ys
                            | x >  y = y : merge xss ys

mergesort :: (Ord a) => [a] -> [a]
mergesort []  = []
mergesort [x] = [x]
mergesort (x:xs) = merge [x] (mergesort xs)

mergesortr :: (Ord a) => [a] -> [a]
mergesortr = foldr (\x ys -> merge [x] ys) []

mergesortl :: (Ord a) => [a] -> [a]
mergesortl = foldl (\xs y -> merge xs [y]) []


