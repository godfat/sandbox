
module Test where

import Ast
import Translator

test0 = translate ast where (Right ast) = parse "" "1+2*3" -- "(1 + (2 * 3))"
test1 = translate ast where (Right ast) = parse "" "1*2+3" -- "((1 * 2) + 3)"
test2 = translate ast where (Right ast) = parse "" "-2.1+3"-- "(-2.1 + 3)"
