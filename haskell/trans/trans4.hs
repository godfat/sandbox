

import Control.Monad.Reader
import Control.Monad.Error

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

eval :: Expr -> ReaderT Env (ErrorT String IO) Val
eval (Lit literal)   = return (Num literal)
eval (Var name)      = do liftIO (putStrLn ("Looking " ++ name ++ "..."))
                          mval <- asks (lookup name)
                          case mval of
                            Nothing  -> throwError ("Var " ++ name ++ " not found.")
                            Just val -> return val

eval (Add exp1 exp2) = do Num a <- eval exp1
                          Num b <- eval exp2
                          liftIO (putStrLn ("Adding " ++ (show a) ++ " and " ++ (show b)))
                          return (Num (a + b))

eval (Lam name expr) = ask >>= return . (Cls name expr)
-- call by value
eval (App exp1 exp2) = do Cls name expr env <- eval exp1
                          val               <- eval exp2
                          local ((:) (name, val)) (eval expr)

test0 = runErrorT (runReaderT (eval (Lit 0)) [])               -- Num 0
test1 = runErrorT (runReaderT (eval (Var "x")) [("x", Num 1)]) -- Num 1
test2 = runErrorT (runReaderT (eval (Add (Lit 1) (Lit 1))) []) -- Num 2
test3 = runErrorT (runReaderT (eval (App (Lam "x" (Add (Lit 1) (Var "x"))) (Lit 2))) []) -- Num 3
test4 = runErrorT (runReaderT (eval (Var "y")) [("x", Num 1)]) -- Left "Var y not found."
test5 = runErrorT (runReaderT (eval (App (Lam "y" (Add (Lit 1) (Var "x"))) (Lit 2))) []) -- Left "Var x not found."
test = [test0, test1, test2, test3, test4, test5]
