
import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr

import qualified Text.ParserCombinators.Parsec.Token as T
import Text.ParserCombinators.Parsec.Language (emptyDef)

run = parse pCalculation "calculator-lex.hs"

lexer :: T.TokenParser ()
lexer = T.makeTokenParser emptyDef

pCalculation :: Parser Double
pCalculation = pExpression <* eof

pExpression :: Parser Double
pExpression = buildExpressionParser opTable pTerm

pTerm :: Parser Double
pTerm = parens pExpression
    <|> try float
    <|> (integer >>= return . fromIntegral)

opTable :: OperatorTable Char () Double
opTable = [firstOp, secondOp]

firstOp, secondOp :: [Operator Char () Double]
firstOp  = [op "*" (*),
            op "/" (/)]

secondOp = [op "+" (+),
            op "-" (-)]

op :: String -> (Double -> Double -> Double) -> Operator Char () Double
op name f = Infix (reservedOp name >> return f) AssocLeft

float      = T.float      lexer
integer    = T.integer    lexer
parens     = T.parens     lexer
reservedOp = T.reservedOp lexer

test0 = run "1 + 1"      -- Right 2.0
test1 = run "1 +  2 * 3" -- Right 7.0
test2 = run "(1 +2) * 3" -- Right 9.0

test3 = run "1 a"        -- Left "calculator-lex.hs" (line 1, column 3):
                         -- unexpected 'a'
                         -- expecting operator or end of input

test4 = run "1 + a"      -- Left "calculator-lex.hs" (line 1, column 5):
                         -- unexpected "a"
                         -- expecting "(", float or integer

test5 = run " 1 +"       -- Left "calculator-lex.hs" (line 1, column 5):
                         -- unexpected end of input
                         -- expecting end of "+", "(", float or integer

test6 = run " 1 ("       -- Left "calculator-lex.hs" (line 1, column 4):
                         -- unexpected '('
                         -- expecting operator or end of input

test7 = run ""           -- Left "calculator-lex.hs" (line 1, column 1):
                         -- unexpected end of input
                         -- expecting "(", float or integer
