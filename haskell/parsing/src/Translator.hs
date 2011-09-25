
module Translator (translate) where

import Ast

translate :: Expr -> String
translate (EDou n  ) = show n
translate (EInt n  ) = show n
translate (ENeg e  ) = unary  "-"   e
translate (ESub l r) = binary " - " l r
translate (EPls l r) = binary " + " l r
translate (EDiv l r) = binary " / " l r
translate (EMul l r) = binary " * " l r

unary :: String -> Expr -> String
unary op e = op ++ translate e

binary :: String -> Expr -> Expr -> String
binary op l r = "(" ++ translate l ++ op ++ translate r ++ ")"
