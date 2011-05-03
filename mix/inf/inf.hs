
-- http://existentialtype.wordpress.com/2011/04/24/the-real-point-of-laziness/

data Nat = Zero | Succ !Nat deriving Show

inf :: Nat
inf = Succ inf
