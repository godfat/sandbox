
import Control.Monad

-- concatMap
combos0 :: [[a]] -> [[a]]
combos0 [] = [[]]
combos0 (xs:xss) = concatMap (\rs -> map (:rs) xs) (combos0 xss)

-- list comprehension
combos1 :: [[a]] -> [[a]]
combos1 [] = [[]]
combos1 (xs:xss) = [ x : rs | x <- xs, rs <- combos1 xss ]

combos2 :: [[a]] -> [[a]]
combos2 [] = [[]]
combos2 (xs:xss) = do{ x <- xs; rs <- combos2 xss; return (x : rs) }

combos3 :: [[a]] -> [[a]]
combos3 [] = [[]]
combos3 (xs:xss) = xs `monadic_cons` (combos3 xss) where
                       monadic_cons = liftM2 (:)

-- list monad
combos :: [[a]] -> [[a]]
combos = foldr (liftM2 (:)) [[]]

{-
*Main> combos [[0..2],[3..4],[5..7]]
[[0,3,5],[0,3,6],[0,3,7],[0,4,5],[0,4,6],[0,4,7],
 [1,3,5],[1,3,6],[1,3,7],[1,4,5],[1,4,6],[1,4,7],
 [2,3,5],[2,3,6],[2,3,7],[2,4,5],[2,4,6],[2,4,7]]
-}
