
Arithmetic expression parser using Parsec

\section{ Introduction }
This program defines a very simple Int parser and Double parser.
Later we would use those parsers to define our calculator parser.

First we import the Parsec module and define a convenient function
for running our test cases. We'll talk about Applicative functor later.

\begin{code}
import Control.Applicative hiding ((<|>))
import Text.ParserCombinators.Parsec
run p = parse p "calculator.lhs"
\end{code}



\section{ Int Parser }
This is a very straightforward Int parser.
To translate this syntax into regular expression,
this means an Int is \d+ (one digit or more than one digits).
Then we convert the string containing the Int to Int via `read',
and `return' it via Parser monad.

\begin{code}
pInt :: Parser Int
pInt = do
  val <- many1 digit
  return (read val)
\end{code}



\section{ Int Parser: test }
As we can see here in the test, it works as expected, converting from
"123" to 123. One thing which might be unexpected is that "123a" is
converted to 123 instead of raising syntax error. This is because
parsing does not need to end at the end of the source, that is we
don't consume all the input.

\begin{code}
test0 = run pInt "123"  -- Right 123
test1 = run pInt "123a" -- Right 123
test2 = run pInt "12a"  -- Right 12
test3 = run pInt "a23"  -- Left "calculator0.hs" (line 1, column 1):
                        -- unexpected "a"
                        -- expecting digit
\end{code}

If we want it to be exactly matched, that is all input should be consumed,
then we can add combine another parser called `eof' to match the end of
input (zerowidth). Something like:

\begin{code}
pInt' :: Parser Int
pInt' = do
  val <- many1 digit
  eof
  return (read val)

test4 = run pInt "123a" -- Left "calculator.lhs" (line 1, column 4):
                        -- unexpected 'a'
                        -- expecting digit or end of input
\end{code}



\section{ Double Parser }
So a Double parser is two Int parsers combined with a '.' parser.
We can first read an Int from the first Int parser, and then use a
'.' parser parse the point, and then discard it, because we don't need
any information on that point. Then we use the second Int parser to
parse the second part of the double. Finally, we build the
double value from the first int and the second int.

\begin{code}
pDouble :: Parser Double
pDouble = do
  left  <- pInt
  char '.'
  right <- pInt
  return (read (show left ++ "." ++ show right))
\end{code}



\section{ Double Parser: test }
Just like the Int parser, the Double parser also didn't care about eof.
So "1.2.3" would be parsed as 1.2 instead of syntax error. We won't put
eof parser here because what we want at last is an arithmetic expression
parser. We'll put that eof parser on the last parser which we would use.

\begin{code}
test5 = run pDouble "12.3"  -- Right 12.3
test6 = run pDouble "1.2.3" -- Right 1.2
test7 = run pDouble ".12.3" -- Left "calculator0.hs" (line 1, column 1):
                            -- unexpected "."
                            -- expecting digit
test8 = run pDouble "123"   -- Left "calculator0.hs" (line 1, column 4):
                            -- unexpected end of input
                            -- expecting digit or "."
\end{code}



\section{ Number Parser }
Here we would see something different. A Number parser which would parse
either an int or a double. We use (<|>) operator in Parsec to parse either
with the first parser or the second parser. First we `try' Double parser,
if it parsed, the we return that result. If it failed, then we parse with
the second (right hand side) parser.

\begin{code}
pNum :: Parser Double
pNum = try pDouble <|> (pInt >>= return . fromIntegral)
\end{code}

Because Int parser returns an int instead of a double, so here we use
`fromIntegral' to convert that int to double to satisfy the type checker.



\section{ Number Parser: alternative }
The reason why we use `try' for the first parser is because Parsec
would not do lookahead match by default, and the match begin from
the first parser, if it matches, then it won't try the second parser.
This is why we need to try to parse double first. If we try to parse
int first, since a double is also an int before the point, it would
never parse double, and if we don't do lookahead match, when we fail
to parse double, we would end up with that the input has already been
consumed. This default is due to performance reason. This way, we can
build up efficient parser which would not do lookahead if possible.

But actually we only need to do lookahead parsing after the point,
the first int before the point is needed either for int or double.
So we don't have to do lookahead on the first int. To do this,
we can't use the Double parser we built above, because it didn't do
any lookahead at all.

\begin{code}
pNum' :: Parser Double
pNum' = do
  left <- many1 digit
  (do
     char '.'
     right <- many1 digit
     return (read (left ++ "." ++ right))) <|> return (read left)
\end{code}

Here we tell the alternative Number parser to parse the first int,
and then try to parse the point. If it failed, then we knew that
this is an int instead of a double. This would work because the point
parser won't accidentally consume input and we don't need to backtrack
(i.e. lookahead). This should run faster than the above one, although
I didn't benchmark it. Anyway, since premature optimization is the
root of all evil, we pick the easy one which uses `try' first.



\section{ Calculation Parser }
Here things start getting interesting. (<*) means we only take the parse
result of the left hand side of the operator, but, the parser on the right
hand side of the operator should also parse. We don't want the result,
but it should also parse by sequence.

So our arithmetic expression parser parses an Expression and an `eof',
and we discard the eof, only taking the result of the Expression parser.
We would define the Expression parser later.

\begin{code}
pCalculation :: Parser Double
pCalculation = pExpression <* eof
\end{code}



\section{ Group Parser }
And a Group parser is an expression grouped by parentheses.
Also, we don't want the result of parentheses, only the expression.

\begin{code}
pGroup :: Parser Double
pGroup = char '(' *> pExpression <* char ')'
\end{code}



\section{ Factor Parser }
A Factor is either a Group or a Number. We define this because we want
to associate '*' and '/' first instead of treating all operators the same.

\begin{code}
pFactor :: Parser Double
pFactor = pGroup <|> pNum
\end{code}



\section{ Term Parser }
Then a Term is a Factor '*' or '/' and a Term, using (*) or (/) on operands.
Because parser combinator defines an LL parser, we need to put recursive
cases on the last to avoid endless recursions. A Term is also a Factor,
otherwise there's no base case. (or we should say Factor is the base case)

\begin{code}
pTerm' :: Parser Double
pTerm' = try ((*) <$> pFactor <*> (char '*' *> pTerm'))
     <|> try ((/) <$> pFactor <*> (char '/' *> pTerm'))
     <|> pFactor
\end{code}



\section{ Term Parser: Make it look better }
But using fmap (<$>) is ugly! We would want to put the parsing actions
the end, not upfront, because at this point, we're more interested at
the syntax instead of actions. We introduce (<&>) to combine parsing
results instead of using ap (<*>), and `using' instead of fmap (<$>).

\begin{code}
(<&>) :: (Monad m) => m a -> m b -> m (a, b)
pa <&> pb = do
  a <- pa
  b <- pb
  return (a, b)

p `using` f = (uncurry f) <$> p

pTerm :: Parser Double
pTerm = try (pFactor <&> (char '*' *> pTerm) `using` (*))
    <|> try (pFactor <&> (char '/' *> pTerm) `using` (/))
    <|> pFactor
\end{code}

Does this look better?



\section{ Expression Parser }
The same goes to '+' and '-'. An Expression is a Term '+' or '-' an
Expression, using (+) or (-) on operands.

\begin{code}
pExpression :: Parser Double
pExpression = try (pTerm <&> (char '+' *> pExpression) `using` (+))
          <|> try (pTerm <&> (char '-' *> pExpression) `using` (-))
          <|> pTerm
\end{code}



\section{ Double Parser: test }
Let's see what we have done...

\begin{code}
test9  = run pCalculation "1+2*3"   -- Right 7.0
test10 = run pCalculation "(1+2)*3" -- Right 9.0
test11 = run pCalculation "40-32/2" -- Right 24.0
test12 = run pCalculation "1+2a" -- Left "calculator.lhs" (line 1, column 4):
                                 -- unexpected 'a'
                                 -- expecting digit or end of input
\end{code}



\section{ What's Next }
So far so good, but one drawback is that we can't use spaces to separate
operators and operands. All spaces are forbidden. We can introduce a
lexer to help us tokenize operators and operands. Then we don't have to
pollute our syntax definition with optional spaces.

I'll cover this if I have more time... To be continued, hopefully.
