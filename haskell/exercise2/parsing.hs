
module Parsing where

data Tree = A | B | Bin (Tree, Tree) deriving (Show)

type Parser a b = [a] -> [(b, [a])]

pTree :: Parser Char Tree
pTree = (lit '(' *> pTree <*> lit ',' *> pTree <* lit ')') `using` Bin
     <|> lit 'a'                                           `using` (const A)
     <|> lit 'b'                                           `using` (const B)

parse :: Parser a b -> [a] -> b
parse p = fst . head . filter (null . snd) . p

fail :: Parser a b
fail xs = []

succeed :: Parser a ()
succeed xs = [((), xs)]

lit :: Eq a => a -> Parser a a
lit x (y : xs) | x == y = [(y, xs)]
lit x _ = []

infixr 6 <|>
(<|>) :: Parser a b -> Parser a b -> Parser a b
(p1 <|> p2) xs = p1 xs ++ p2 xs

-- apply :: ?
apply p1 p2 f xs = concat $ map f result where
                         p1_result = p1 xs
                         p2_result = map (\x -> p2 x) (map snd p1_result)
                         result = zip p1_result p2_result

infixr 7 <*>
(<*>) :: Parser a b -> Parser a c -> Parser a (b,c)
-- (p1 <*> p2) xs = concat $ map (\(r1, r2) ->
--                           map (\(rr1, rr2) -> ((fst rr1, fst rr2), snd rr2))
--                             (zip (cycle [r1]) r2) ) result where
--                     p1_result = p1 xs
--                     p2_result = map (\x -> p2 x) (map snd p1_result)
--                     result = zip p1_result p2_result

-- (p1 <*> p2) xs = concat $ map (\(r1, r2) -> [(((fst r1), fst r2), snd r2) | r2 <- r2]) result where
--                     p1_result = p1 xs
--                     p2_result = map (\x -> p2 x) (map snd p1_result)
--                     result = zip p1_result p2_result

p1 <*> p2 = apply p1 p2 (\(r1, r2) -> [((fst r1, fst r2), snd r2) | r2 <- r2])

using :: Parser a b -> (b -> c) -> Parser a c
(p `using` f) xs = map (\(b, a) -> (f b, a)) (p xs)


infixr 8 *>
(*>) :: Parser a b -> Parser a c -> Parser a c
p1 *> p2 = apply p1 p2 (\(r1, r2) -> [(fst r2, snd r2) | r2 <- r2])


infixr 8 <*
(<*) :: Parser a b -> Parser a c -> Parser a b
p1 <* p2 = apply p1 p2 (\(r1, r2) -> [(fst r1, snd r2) | r2 <- r2])


pB :: Parser Char Int
pB =   lit '0' `using` (const 0)
  <|>  lit '1' `using` (const 1)
  <|> (lit '0' *> pB) `using` (2*)
  <|> (lit '1' *> pB) `using` ((+1).(2*))

pB' :: Parser Char Int
pB' =  lit '0' `using` (const 0)
   <|> lit '1' `using` (const 1)
   <|> (pB' <* lit '0') `using` (2*)
   <|> (pB' <* lit '1') `using` ((+1).(2*))

pB'' :: Parser Char Int
pB'' = pB . reverse

pTree' :: Parser Char Tree
pTree' = (lit '(' *> pTree' <*> lit ')' *> pTree') `using` Bin
      <|> lit 'a'                                  `using` (const A)
      <|> lit 'b'                                  `using` (const B)

digit :: Parser Char Char
digit (x : xs) = if elem x "0123456789." then [(x, xs)] else []
digit _ = []

to_s :: Parser Char String
to_s = (digit <*> to_s) `using` (uncurry (:))
    <|> digit `using` (\n->[n])

group :: Parser Char Float
group = lit '(' *> expression <* lit ')'

factor :: Parser Char Float
factor =  to_s `using` read
      <|> group

term :: Parser Char Float
term =  (factor <*> lit '*' *> term) `using` (uncurry (*))
    <|> (factor <*> lit '/' *> term) `using` (uncurry (/))
    <|>  factor

expression :: Parser Char Float
expression =  (term <*> lit '+' *> expression) `using` (uncurry (+))
          <|> (term <*> lit '-' *> expression) `using` (uncurry (-))
          <|>  term

