
main = putStrLn . show $
  sum [x | x <- [0..999], x `mod` 3 * x `mod` 5 == 0]
