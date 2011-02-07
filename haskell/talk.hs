
map' :: (a -> b) -> [a] -> [b]
map' f [] = []
map' f (x:xs) = f x : map' f xs

foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' f v [] = v
foldl' f v (x:xs) = foldl' f (f v x) xs

-- ((((0 - 1) - 2) - 3) - 4)

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f v [] = v
foldr' f v (x:xs) = f x (foldr' f v xs)

-- (1 - (2 - (3 - (4 - 0))))

map'' :: (a -> b) -> [a] -> [b]
map'' f xs = foldr ((:) . f) [] xs

-- eta reduction
map''' :: (a -> b) -> [a] -> [b]
map''' f = foldr ((:) . f) []
-- all function in haskell is curried
-- (\f -> (\xs -> ((foldr ((:).f)) []) xs))
-- (\f -> foldr ((:).f) [])

-- Y = \f -> (\x -> f (x x)) (\x -> f (x x))

fix f = f (fix f)

fact f 0 = 1
fact f x = x * f (x-1)
