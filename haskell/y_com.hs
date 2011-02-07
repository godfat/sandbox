
module Y where

fact :: (Int -> Int) -> Int -> Int
fact f 1 = 1
fact f n = n * f (n-1)

y :: (a -> a) -> a
y f = f (y f)
