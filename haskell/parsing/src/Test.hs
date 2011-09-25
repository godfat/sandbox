
module Test where

import Ast
import Translator

run str = translate ast where (Right ast) = parse "Test.hs" str

test0 = run "1+2*3"  -- "(1 + (2 * 3))"
test1 = run "1*2+3"  -- "((1 * 2) + 3)"
test2 = run "-2.1+3" -- "(-2.1 + 3)"
test3 = run "1+-1"   -- "(1 + -1)"
test4 = run "-1"     -- "-1"
test5 = run "-1.2"   -- "-1.2"
test6 = run "-(1)"   -- "-1"
test7 = run "-(1-2)" -- "-(1 - 2)"
