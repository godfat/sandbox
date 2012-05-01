
module FPUG.Last where

import Prelude              hiding (fail)
import Control.Monad.Reader hiding (fail)

import Test.HUnit (Test(TestCase, TestList), assertEqual, runTestTT)

data Expr = Lit Int
          | Var Name
          | Pls Expr Expr
          | Lam Name Expr
          | App Expr Expr
            deriving (Show, Eq)

data Val  = Num Int
          | Cls Name Expr Env
            deriving (Show, Eq)

type Name = String
type Msg  = String

type Env  = [(Name, Val)]
type Res  = ReaderT Env (Either String) Val

eval :: Expr -> Res
eval (Lit i)            = return (Num i)
eval (Pls expr0 expr1)  = join $ liftM2 plus (eval expr0) (eval expr1)

eval (Var n)            = asks (lookup n) >>= check
  where  check  Nothing = fail $ "Variable `" ++ n ++ "' not found."
         check (Just v) = return v

eval (Lam name expr)    = asks (Cls name expr)
eval (App expr0 expr1)  = do Cls name expr env <- eval expr0
                             val               <- eval expr1
                             local ((++env) . ((name, val):)) (eval expr)

exec :: Expr -> Either String Val
exec = flip (runReaderT . eval) []

plus :: Val -> Val -> Res
plus (Num a) (Num b) = return (Num (a + b))
plus (Num a)      b  = nan b
plus      a       _  = nan a

fail :: Msg -> Res
fail = lift . Left

nan :: Val -> Res
nan v = fail $ "`" ++ show v ++ "'" ++ " is not a number."

---------------------------------------------------------------------------

main = runTestTT $ TestList [test0, test1, test2, test3,
                             test4, test5, test6, test7]

testCase lhs rhs = TestCase $ assertEqual "" lhs rhs

test0 = testCase (Right (Num 1)) (exec (Lit 1))
test1 = testCase (Right (Num 3)) (exec (Pls (Lit 1) (Lit 2)))
test2 = testCase (Right (Num 6)) (exec (Pls (Pls (Lit 1) (Lit 2)) (Lit 3)))
test3 = testCase (Left "Variable `bad' not found.") (exec (Var "bad"))
test4 = testCase (Right (Num 7))
                    ((runReaderT . eval) (Var "ok") [("ok", Num 7)])
test5 = testCase (Right (Cls "x" (Lit 1) [])) (exec (Lam "x" (Lit 1)))
test6 = testCase (Right (Num 8))
                    (exec (Pls (App (Lam "x" (Var "x")) (Lit 5)) (Lit 3)))
test7 = testCase (Right (Num 9))
                    (exec (App (App (Lam "x" (Lam "y"
                               (Pls (Var "x") (Var "y")))) (Lit 5)) (Lit 4)))
