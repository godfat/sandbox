
import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec
import Text.ParserCombinators.Parsec.Expr

import qualified Text.ParserCombinators.Parsec.Token as T
import Text.ParserCombinators.Parsec.Language (emptyDef)

run = parse pCalculation "calculator-ast.hs"

data Expr = Mul Expr Expr |
            Div Expr Expr |
            Pls Expr Expr |
            Sub Expr Expr |
            Num Double deriving (Show, Eq)

lexer :: T.TokenParser ()
lexer = T.makeTokenParser emptyDef

pCalculation, pExpression, pTerm :: Parser Expr

pCalculation =  pExpression <* eof
pExpression  =  buildExpressionParser opTable pTerm
pTerm        =  parens pExpression
            <|> try (float >>= return . Num)
            <|> (integer >>= return . Num . fromIntegral)

opTable :: OperatorTable Char () Expr
opTable = [firstOp, secondOp]

firstOp, secondOp :: [Operator Char () Expr]
firstOp  = [op "*" Mul,
            op "/" Div]

secondOp = [op "+" Pls,
            op "-" Sub]

op :: String -> (Expr -> Expr -> Expr) -> Operator Char () Expr
op name f = Infix (reservedOp name >> return f) AssocLeft

float      = T.float      lexer
integer    = T.integer    lexer
parens     = T.parens     lexer
reservedOp = T.reservedOp lexer

test0 = run "1 + 1"      -- Right (Pls (Num 1.0) (Num 1.0))
test1 = run "1 +  2 * 3" -- Right (Pls (Num 1.0) (Mul (Num 2.0) (Num 3.0)))
test2 = run "(1 +2) * 3" -- Right (Mul (Pls (Num 1.0) (Num 2.0)) (Num 3.0))
