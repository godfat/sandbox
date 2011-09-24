
Arithmetic expression parser using Parsec

\section{ Introduction }
This program defines a very simple Int parser and Double parser.
Later we would use those parsers to define our calculator parser.

First we import the Parsec module and define a convenient function
for running our test cases.

\begin{code}
import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec
run p = parse p "calculator0.hs"
\end{code}



\section{ Int Parser }
This is a very straightforward Int parser.
To translate this into regular expression,
this means an Int is \d+ (one digit or more than one digits)
Then we convert the string containing the Int to Int via `read',
and `return' it via Parser monad.

\begin{code}
pInt :: Parser Int
pInt = do
  val <- many1 digit
  return (read val)
\end{code}



\section{ Int Parser: test }
\begin{code}
test0 = run pInt "123"  -- Right 123
test1 = run pInt "123a" -- Right 123
test2 = run pInt "12a"  -- Right 12
test3 = run pInt "a23"  -- Left "calculator0.hs" (line 1, column 1):
                        -- unexpected "a"
                        -- expecting digit
\end{code}



\section{ Double Parser }
\begin{code}
pDouble :: Parser Double
pDouble = do
  left  <- pInt
  char '.'
  right <- pInt
  return (read (show left ++ "." ++ show right))
\end{code}



\section{ Double Parser: test }
\begin{code}
test4 = run pDouble "12.3"  -- Right 12.3
test5 = run pDouble "1.2.3" -- Right 1.2
test6 = run pDouble ".12.3" -- Left "calculator0.hs" (line 1, column 1):
                            -- unexpected "."
                            -- expecting digit
test7 = run pDouble "123"   -- Left "calculator0.hs" (line 1, column 4):
                            -- unexpected end of input
                            -- expecting digit or "."
\end{code}



\section{ Number Parser }
\begin{code}
pNum :: Parser Double
pNum = try pDouble <|> (pInt >>= return . fromIntegral)
\end{code}



\section{ Number Parser: alternative }
\begin{code}
pNum' :: Parser Double
pNum' = do
  left <- many1 digit
  (do
     char '.'
     right <- many1 digit
     return (read (left ++ "." ++ right))) <|> return (read left)
\end{code}



\section{ Calculation Parser }
\begin{code}
pCalculation :: Parser Double
pCalculation = pExpression <* eof
\end{code}



\section{ Group Parser }
\begin{code}
pGroup :: Parser Double
pGroup = char '(' *> pExpression <* char ')'
\end{code}



\section{ Factor Parser }
\begin{code}
pFactor :: Parser Double
pFactor = pGroup <|> pNum
\end{code}



\section{ Term Parser }
\begin{code}
pTerm :: Parser Double
pTerm = try ((*) <$> pFactor <*> (char '*' *> pTerm))
    <|> try ((/) <$> pFactor <*> (char '/' *> pTerm))
    <|> pFactor
\end{code}



\section{ Expression Parser }
\begin{code}
pExpression :: Parser Double
pExpression = try ((+) <$> pTerm <*> (char '+' *> pExpression))
          <|> try ((-) <$> pTerm <*> (char '-' *> pExpression))
          <|> pTerm
\end{code}



\section{ Double Parser: test }
\begin{code}
test12 = run pCalculation "1+2*3"
test13 = run pCalculation "40-32/2"
\end{code}
