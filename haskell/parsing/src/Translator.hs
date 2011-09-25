
module Translator (translate) where

import Ast

translate :: Expr -> String
translate (EDou n  ) = show n
translate (EInt n  ) = show n
translate (ESub l r) = translate' " - " l r
translate (EPls l r) = translate' " + " l r
translate (EDiv l r) = translate' " / " l r
translate (EMul l r) = translate' " * " l r

translate' :: String -> Expr -> Expr -> String
translate' op l r = "(" ++ translate l ++ op ++ translate r ++ ")"
