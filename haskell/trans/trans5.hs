

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
eval (Var name)      = do liftIO (putStrLn ("Looking for " ++ name ++ "..."))
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
                          local ((name, val):) (eval expr)

extract :: Expr -> Env -> IO (Either String (Val, Integer))
extract expr env = runErrorT (runStateT (runReaderT (eval expr) env) 1)

test0 = extract (Lit 0) []               -- Right (Num 0, 1)
test1 = extract (Var "x") [("x", Num 1)] -- Right (Num 1, 2)
test2 = extract (Add (Lit 1) (Lit 1)) [] -- Right (Num 2, 1)
test3 = extract (App (Lam "x" (Add (Lit 1) (Var "x"))) (Lit 2)) []
                                         -- Right (Num 3,2)
test4 = extract (Var "y") [("x", Num 1)] -- Left "Var y not found."
test5 = extract (App (Lam "y" (Add (Lit 1) (Var "x"))) (Lit 2)) []
                                         -- Left "Var x not found."
test = mapM_ (>>= print) [test0, test1, test2, test3, test4, test5]
