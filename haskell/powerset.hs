{-# LANGUAGE ScopedTypeVariables #-}

import Control.Monad (filterM)

--         1.16 real         0.05 user         0.01 sys
powerset :: [a] -> [[a]]
powerset = filterM (const [True, False])



--         1.65 real         0.08 user         0.01 sys
powerset' :: forall a. [a] -> [[a]]
powerset'     [] = [[]]
powerset' (x:xs) = concat $ map (powerset_) [True, False] where
  powerset_ :: Bool -> [[a]]
  powerset_ flg = map (\ys -> if flg then x:ys else ys) (powerset' xs)



--         1.64 real         0.09 user         0.01 sys
powerset'' :: [a] -> [[a]]
powerset''     [] = [[]]
powerset'' (x:xs) = map (x:) (powerset'' xs) ++ (powerset'' xs)
--                 True part
--                                           False part



--         1.53 real         0.08 user         0.01 sys
powerset''' :: [a] -> [[a]]
powerset'''     [] =  [[]]
powerset''' (x:xs) = do
  flag <- [True, False]
  ys   <- powerset''' xs
  if flag then
    return (x:ys)
  else
    return ys



--         1.44 real         0.06 user         0.01 sys
powerset'''' :: [a] -> [[a]]
powerset'''' = (powerset''''rec (:[])) . reverse

powerset''''rec :: ([a] -> [[a]]) -> [a] -> [[a]]
powerset''''rec k     [] = k []
powerset''''rec k (x:xs) = powerset''''rec (\r -> (map (x:) (k r)) ++ k r) xs



main = putStrLn $ show $ powerset'''' [1..15]
