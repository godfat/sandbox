

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
         | Cls Name Expr Env
         deriving (Show)

eval :: Expr -> ReaderT Env Maybe Val
eval (Lit literal)   = return (Num literal)
eval (Var name)      = ReaderT (asks (lookup name))
eval (Add exp1 exp2) = do Num a <- eval exp1
                          Num b <- eval exp2
                          return (Num (a + b))

eval (Lam name expr) = ask >>= return . (Cls name expr)
-- call by value
eval (App exp1 exp2) = do Cls name expr env <- eval exp1
                          val               <- eval exp2
                          local ((:) (name, val)) (eval expr)

test0 = runReaderT (eval (Lit 0)) []               -- Num 0
test1 = runReaderT (eval (Var "x")) [("x", Num 1)] -- Num 1
test2 = runReaderT (eval (Add (Lit 1) (Lit 1))) [] -- Num 2
test3 = runReaderT (eval (App (Lam "x" (Add (Lit 1) (Var "x"))) (Lit 2))) [] -- Num 3
test4 = runReaderT (eval (Var "y")) [("x", Num 1)] -- Nothing
test5 = runReaderT (eval (App (Lam "y" (Add (Lit 1) (Var "x"))) (Lit 2))) [] -- Nothing
test = [test0, test1, test2, test3, test4, test5]
