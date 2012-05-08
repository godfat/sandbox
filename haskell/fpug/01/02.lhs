
> module Main where

> data Expression = Literal Integer
>                 | Plus Expression Expression
>                 | Variable String

> type Environment = [(String, Integer)]
> type Value = Maybe Integer

> evaluate :: Expression -> Environment -> Value
> evaluate (Literal i)        env = Just i
> evaluate (Variable name)    env = lookup name env
> evaluate (Plus expr0 expr1) env =
>   let val0 = evaluate expr0 env
>       val1 = evaluate expr1 env
>   in
>       case val0 of (Nothing) -> Nothing
>                    (Just i0) -> case val1 of (Nothing) -> Nothing
>                                              (Just i1) -> Just (i0 + i1)


> main = print [test0, test1]

> test0 = evaluate (Variable "var") [("var", 1)]
> test1 = evaluate (Plus (Variable "var") (Literal 2)) []
