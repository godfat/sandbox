
import Control.Monad (filterM)

powerset :: [a] -> [[a]]
powerset     [] = [[]]
powerset (x:xs) = concat $ map (powerset') [True, False] where
  -- powerset' :: Bool -> [[a]]
  powerset' flg = map (\ys -> if flg then x:ys else ys) (powerset xs)

powerset' :: [a] -> [[a]]
powerset'     [] = [[]]
powerset' (x:xs) = map (x:) (powerset xs) ++ (powerset xs)
--                 True part
--                                           False part

powerset'' :: [a] -> [[a]]
powerset'' = filterM (const [True, False])

powerset''' :: [a] -> [[a]]
powerset'''     [] =  [[]]
powerset''' (x:xs) = do
  flag <- [True, False]
  ys   <- powerset''' xs
  if flag then
    return (x:ys)
  else
    return ys
