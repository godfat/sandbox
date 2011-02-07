{-# OPTIONS -XFlexibleInstances #-}

import Data.Maybe (fromJust)


type Name = String

data Expr = Lit Int
          | Var Name
          | Add Expr Expr
          | Lam Name Expr
          | App Expr Expr
          deriving (Show)

type Env = [(Name, Val)]

data Val = Num Int
         | Cls (Val -> Val)
         deriving (Show)

instance Show (a -> a) where
  show f = "a -> a"

eval :: Expr -> Env -> Val
eval (Lit literal)   _   = Num literal
eval (Var name)      env = fromJust (lookup name env)
eval (Add exp1 exp2) env = Num (a + b) where
                           Num a = eval exp1 env
                           Num b = eval exp2 env

eval (Lam name expr) env = Cls (\arg -> eval expr ((name, arg) : env))


-- call by value
eval (App exp1 exp2) env = cls (eval exp2 env) where
                           Cls cls = eval exp1 env


test0 = eval (Lit 0) []               -- Num 0
test1 = eval (Var "x") [("x", Num 1)] -- Num 1
test2 = eval (Add (Lit 1) (Lit 1)) [] -- Num 2
test3 = eval (App (Lam "x" (Add (Lit 1) (Var "x"))) (Lit 2)) [] -- Num 3
test4 = eval (Var "y") [("x", Num 1)] -- Nothing
test5 = eval (App (Lam "y" (Add (Lit 1) (Var "x"))) (Lit 2)) [] -- Nothing
test = [test0, test1, test2, test3, test4, test5]
