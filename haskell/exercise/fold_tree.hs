
module FoldTree where

data Tree a = Tip a | Bin (Tree a) (Tree a) deriving Show

--  1.1 Given:
foldTree :: (b -> b -> b) -> (a -> b) -> Tree a -> b
foldTree f g (Tip a)   = g a
foldTree f g (Bin t u) = f (foldTree f g t)
                           (foldTree f g u)
--      Can you define flatten in terms of foldTree?

flatten :: Tree a -> [a]
flatten = foldTree (++) (:[])

test_tree1 = Bin (Bin (Tip 1) (Tip 2)) (Bin (Tip 3) (Tip 4))
test_tree2 = Bin (Bin (Tip 1) (Bin (Tip 2) (Tip 3))) (Bin (Tip 4) (Tip 5))


{-
fastflatten :: Tree a -> [a] -> [a]
fastflatten t xs = foldTree ( \lhs rhs -> (++) (lhs []) . rhs ) (:) t xs

fastflatten Bin (Bin (Tip 1) (Tip 2)) (Bin (Tip 3) (Tip 4)) []
    = foldTree f (:) t []
    = f ( foldTree f (:) (Bin (Tip 1) (Tip 2)) ) ( foldTree f (:) (Bin (Tip 3) (Tip 4)) ) []
    = f (f (foldTree f (:) (Tip 1)) (foldTree f (:) (Tip 2)))
           (foldTree f (:) (Tip 3)) (foldTree f (:) (Tip 4))) []
    = f (f (1:) (2:)) (f (3:) (4:)) []
    = f ((++) (1:[]) . (2:)) ((++) (3:[]) . (4:)) []
    = (++) (((++) (1:[]) . (2:)) []) . ((++) (3:[]) . (4:)) []
    = (1:[] ++ 2:[]) ++ (3:[] ++ 4:[])
    = [1:2] ++ [3:4]
-}

fastflatten :: Tree a -> [a] -> [a]
fastflatten = foldTree (.) (:)

{-
fastflatten Bin (Bin (Tip 1) (Tip 2)) (Bin (Tip 3) (Tip 4)) []
    = foldTree f (:) t []
    = f ( foldTree f (:) (Bin (Tip 1) (Tip 2)) ) ( foldTree f (:) (Bin (Tip 3) (Tip 4)) ) []
    = f (f (foldTree f (:) (Tip 1)) (foldTree f (:) (Tip 2)))
           (foldTree f (:) (Tip 3)) (foldTree f (:) (Tip 4))) []
    = f (f (1:) (2:)) (f (3:) (4:)) []
    = (.) ((1:) . (2:)) ((3:) . (4:)) []
    = ((1:) . (2:)) . ((3:) . (4:)) []
    = 1:2:3:4:[]
-}
