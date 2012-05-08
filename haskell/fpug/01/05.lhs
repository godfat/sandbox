
> module Main where
> import Control.Monad (liftM2)

> data Expression = Literal Integer
>                 | Plus Expression Expression
>                 | Variable String

> type Environment = [(String, Integer)]
> type Value = Maybe Integer

> evaluate :: Expression -> Environment -> Value
> evaluate (Literal i)        env = Just i
> evaluate (Variable name)    env = lookup name env
> evaluate (Plus expr0 expr1) env =
>   evaluate expr0 env `plus` evaluate expr1 env where
>   plus = liftM2 (+)


> main = print [test0, test1]

> test0 = evaluate (Variable "var") [("var", 1)]
> test1 = evaluate (Plus (Variable "var") (Literal 2)) []
