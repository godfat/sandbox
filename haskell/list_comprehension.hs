
module ListComprehension where

import List (delete)

permutation [] = [[]]  
permutation xs = [x:ys | x <- xs, ys <- permutation (delete x xs)]

xs = [1..2]
ys = [3..4]

a = [ (x, y) | x <- xs | y <- ys ] 

