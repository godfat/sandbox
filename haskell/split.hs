
input_1 = "FFFF:0012:0000:1234:0090:0000:0000:0000"
input_2 = "0000:0000:0000:FF00:0000:0000:0FF0:00FF"

split :: (Eq a) => a -> [a] -> [[a]]
split ch = foldr (\i r-> if i /= ch then (i : (head r)) : (tail r)
                       else [] : r) [[]]


join :: [a] -> [[a]] -> [a]
-- join sep strs = reverse $ tail $ reverse $ foldr (\i r-> i ++ sep ++ r) [] strs
join sep (s:[]) = s
join sep (s:ss) = s ++ sep ++ (join sep ss)


squeeze :: (Eq a) => [a] -> [a]
squeeze (s1:s2:ss) = if s1 == s2 then squeeze (s1:ss)
                   else s1 : squeeze (s2:ss)
squeeze s = s

snip_zero :: [Char] -> [Char]
snip_zero (n:[]) = "0"
snip_zero (n:ns) = if n == '0' then snip_zero ns
                 else n:ns

-- ["FFFF","12","0","1234","90","0","0","0"]
ipv6 str = map snip_zero $ split ':' str
