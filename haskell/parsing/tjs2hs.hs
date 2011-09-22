
import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec

-- pInt :: Parser Int
-- pInt = do
--   val <- many1 digit
--   return (read val)

-- pDouble :: Parser Double
-- pDouble = do
--   left  <- pInt
--   char '.'
--   right <- pInt
--   return (read (show left ++ "." ++ show right))

pInt :: Parser Int
pInt = read <$> many1 digit

pDouble :: Parser Double
pDouble = num <$> pInt <*> (char '.' *> pInt) where
          num l r = read $ show l ++ "." ++ show r

pNum :: Parser Double
pNum = try pDouble <|> (pInt >>= return . fromIntegral)

pGroup :: Parser Double
pGroup = char '(' *> pExpression <* char ')'

pFactor :: Parser Double
pFactor = pGroup <|> pNum

pTerm :: Parser Double
pTerm = try ((*) <$> pFactor <*> (char '*' *> pTerm))
    <|> try ((/) <$> pFactor <*> (char '/' *> pTerm))
    <|> pFactor

pExpression :: Parser Double
pExpression = try ((+) <$> pTerm <*> (char '+' *> pExpression))
          <|> try ((-) <$> pTerm <*> (char '-' *> pExpression))
          <|> pTerm

pCalculate :: Parser Double
pCalculate = pExpression <* eof



pNum' :: Parser Double
pNum' = do
  left <- many1 digit
  (do
     char '.'
     right <- many1 digit
     return (read (left ++ "." ++ right))) <|> return (read left)

pNum'' :: Parser Double
pNum'' = do
  left <- many1 digit
  (try (char '.') >>
    do
      right <- many1 digit
      return (read (left ++ "." ++ right))) <|> return (read left)
