{-# OPTIONS -XFlexibleInstances #-}

import Data.Maybe (fromJust)
import Control.Monad.Reader

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

eval :: Expr -> Reader Env Val
eval (Lit literal)   = return (Num literal)
eval (Var name)      = asks (lookup name) >>= return . fromJust
eval (Add exp1 exp2) = do Num a <- eval exp1
                          Num b <- eval exp2
                          return (Num (a + b))

eval (Lam name expr) =
  ask >>= \env ->
  return (Cls (\arg -> runReader (eval expr) ((name, arg) : env)))
-- call by value
eval (App exp1 exp2) = do Cls cls <- eval exp1
                          val     <- eval exp2
                          return (cls val)

test0 = runReader (eval (Lit 0)) []               -- Num 0
test1 = runReader (eval (Var "x")) [("x", Num 1)] -- Num 1
test2 = runReader (eval (Add (Lit 1) (Lit 1))) [] -- Num 2
test3 = runReader (eval (App (Lam "x" (Add (Lit 1) (Var "x"))) (Lit 2))) [] -- Num 3
test4 = runReader (eval (Var "y")) [("x", Num 1)] -- Nothing
test5 = runReader (eval (App (Lam "y" (Add (Lit 1) (Var "x"))) (Lit 2))) [] -- Nothing
test = [test0, test1, test2, test3, test4, test5]
