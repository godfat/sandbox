

square_sum :: [Int] -> Int
square_sum xs = foldr (\x y -> x * x + y) 0 xs

square_sum' = foldr (\x y -> x * x + y) 0

square_sum'' = foldr (curry (\xs -> (+) ((product . ((replicate 2) . fst)) xs) (snd xs))) 0

square_sum''' = zip (replicate 2)
