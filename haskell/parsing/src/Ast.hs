
module Ast (Expr(..), Ast.parse) where

import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec as P
import Text.ParserCombinators.Parsec.Expr

import qualified Text.ParserCombinators.Parsec.Token as T
import Text.ParserCombinators.Parsec.Language (emptyDef)

data Expr = EMul Expr Expr |
            EDiv Expr Expr |
            EPls Expr Expr |
            ESub Expr Expr |
            ENeg Expr      |
            EInt Integer   |
            EDou Double deriving (Show, Eq)

lexer :: T.TokenParser ()
lexer = T.makeTokenParser emptyDef

parse = P.parse parser

parser, pExpression, pTerm :: Parser Expr
parser =  pExpression <* eof
pExpression  =  buildExpressionParser opTable pTerm
pTerm        =  parens pExpression
            <|> try (float >>= return . EDou)
            <|>   (integer >>= return . EInt)

opTable :: OperatorTable Char () Expr
opTable = [op0, op1, op2]

op0, op1, op2 :: [Operator Char () Expr]
op0 = [unary  "-" ENeg]

op1 = [binary "*" EMul,
       binary "/" EDiv]

op2 = [binary "+" EPls,
       binary "-" ESub]

unary  :: String -> (Expr -> Expr)         -> Operator Char () Expr
unary name f = Prefix (reservedOp name >> return f)

binary :: String -> (Expr -> Expr -> Expr) -> Operator Char () Expr
binary name f = Infix  (reservedOp name >> return f) AssocLeft

float      = T.float      lexer
integer    = T.integer    lexer
parens     = T.parens     lexer
reservedOp = T.reservedOp lexer
