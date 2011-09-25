
module Test where

import Ast
import Translator

main = case (parse "" "1+2*3") of
         (Right ast) -> translate ast
         (Left e)    -> show e
