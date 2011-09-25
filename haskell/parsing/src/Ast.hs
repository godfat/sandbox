
module Ast where

import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec as P
import Text.ParserCombinators.Parsec.Expr

import qualified Text.ParserCombinators.Parsec.Token as T
import Text.ParserCombinators.Parsec.Language (emptyDef)

data Expr = EMul Expr Expr |
            EDiv Expr Expr |
            EPls Expr Expr |
            ESub Expr Expr |
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
opTable = [firstOp, secondOp]

firstOp, secondOp :: [Operator Char () Expr]
firstOp  = [op "*" EMul,
            op "/" EDiv]

secondOp = [op "+" EPls,
            op "-" ESub]

op :: String -> (Expr -> Expr -> Expr) -> Operator Char () Expr
op name f = Infix (reservedOp name >> return f) AssocLeft

float      = T.float      lexer
integer    = T.integer    lexer
parens     = T.parens     lexer
reservedOp = T.reservedOp lexer
