
module Count where

test :: [Int]
test = [zero, zero 123, zero "" [True, False] id (+)]
-- test should be [0,0,0]

test' :: [Int]
test' = [count, count 123, count "" [True, False] id (+)]
-- test should be [0,1,4]

class Count a where
    zero' :: a
    count' :: Int -> a

instance Count Int where
    zero' = 0
    count' = id

instance Count b => Count (a -> b) where
    zero' _ = zero'
    count' n _ = count' (n+1)

zero :: Count a => a
zero = zero'

count :: Count a => a
count = count' 0
