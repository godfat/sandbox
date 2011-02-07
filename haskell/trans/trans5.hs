

import Control.Monad.Reader
import Control.Monad.Error
import Control.Monad.State

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

eval :: Expr -> ReaderT Env (StateT Integer (ErrorT String IO)) Val
eval (Lit literal)   = return (Num literal)
eval (Var name)      = do liftIO (putStrLn ("Looking " ++ name ++ "..."))
                          line <- get
                          put (line + 1)
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

test0 = runStateT (runReaderT (eval (Lit 0)) [])               -- Num 0
test1 = runStateT (runReaderT (eval (Var "x")) [("x", Num 1)]) -- Num 1
test2 = runStateT (runReaderT (eval (Add (Lit 1) (Lit 1))) []) -- Num 2
test3 = runStateT (runReaderT (eval (App (Lam "x" (Add (Lit 1) (Var "x"))) (Lit 2))) []) -- Num 3
test4 = runStateT (runReaderT (eval (Var "y")) [("x", Num 1)]) -- Left "Var y not found."
test5 = runStateT (runReaderT (eval (App (Lam "y" (Add (Lit 1) (Var "x"))) (Lit 2))) []) -- Left "Var x not found."
test = [test0, test1, test2, test3, test4, test5]
