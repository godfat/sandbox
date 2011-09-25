
module Test where

import Ast
import Translator

run str = translate ast where (Right ast) = parse "Test.hs" str

test =
  [run "1+2*3" , -- "(1 + (2 * 3))"
   run "1*2+3" , -- "((1 * 2) + 3)"
   run "-2.1+3", -- "(-2.1 + 3)"
   run "1+-1"  , -- "(1 + -1)"
   run "-1"    , -- "-1"
   run "-1.2"  , -- "-1.2"
   run "-(1)"  , -- "-1"
   run "-(1-2)", -- "-(1 - 2)"
   run "1 + 2" , -- "(1 + 2)"
   run "1 + -1"] -- "(1 + -1)"
