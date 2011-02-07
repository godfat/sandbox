
data BinTree a = Leaf a
               | Branch (BinTree a) (BinTree a) deriving Show

instance Functor BinTree where
  fmap f (Leaf a) = Leaf (f a)
  fmap f (Branch a b) = Branch (fmap f a) (fmap f b)

test1 = Branch (Branch (Leaf 0) (Leaf 1)) (Branch (Leaf 2) (Leaf 3))
test2 = fmap id test1
test3 = fmap (*2) test1
