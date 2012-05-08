
> module Main where

> data Expression = Literal Integer
>                 | Plus Expression Expression
>                 | Variable String

> type Environment = [(String, Integer)]

> evaluate :: Expression -> Environment -> Integer
> evaluate (Literal i)        env = i
> evaluate (Plus expr0 expr1) env = evaluate expr0 env + evaluate expr1 env
> evaluate (Variable name)    env = case lookup name env of
>                                     (Just i) -> i


> main = print [test0, test1]

> test0 = evaluate (Variable "var") [("var", 1)]
> test1 = evaluate (Plus (Variable "var") (Literal 2)) [("var", 1)]
