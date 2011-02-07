
module Ho where

ha :: Integer -> Char -> Char -> Char -> [(Integer, Char, Char)] -> [(Integer, Char, Char)]
ha 0 _ _ _ r = r
ha n f b t r = ha (n-1) f t b r ++ [(n, f, t)] ++ ha (n-1) b f t r

ha' :: Integer -> Char -> Char -> Char -> [(Integer, Char, Char)]
ha' 0 _ _ _ = []
ha' n f b t = ha' (n-1) f t b ++ [(n, f, t)] ++ ha' (n-1) b f t

ha'' :: Integer -> Char -> Char -> Char -> [(Integer, Char, Char)]
ha'' 0 _ _ _ = []
ha'' n f b t = ha'' (n-1) f t b ++ ((n, f, t) : ha'' (n-1) b f t)
