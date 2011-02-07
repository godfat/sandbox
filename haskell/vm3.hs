
-- Splitting Exp and Compt

type Var = String

data Exp = Val Int
         | Var Int
         | Plus Exp Exp
         | Lam Exp 
         | App Exp Exp  deriving Show

data Val = Num Int
         | Clos Env Compt 

type Env = [Val]

-- type Compt = Env -> Cont -> Val

data Cont = Cont0
          | Cont1 Compt Env Cont
          | Cont2 Int Cont
          | Cont3 Compt Env Cont     
          | Cont4 Compt Env Cont  

data Compt = Lit Int
           | Access Int
           | Push1 Compt Compt
           | Close Compt
           | Push2 Compt Compt  deriving Show

eval :: Exp -> Compt
eval (Val m) = Lit m 
eval (Var n) = Access n 
eval (Plus e1 e2) = Push1 (eval e1) (eval e2)
eval (Lam e) = Close (eval e)
eval (App e1 e2) = Push2 (eval e1) (eval e2)

appC :: Compt -> Env -> Cont -> Val
appC (Lit m) env k = appK k (Num m)
appC (Access n) env k = appK k (env !! n)
appC (Push1 c1 c2) env k = appC c1 env (Cont1 c2 env k)
appC (Close c) env k =  appK k (Clos env c)
appC (Push2 c1 c2) env k = appC c1 env (Cont3 c2 env k)
 
appK :: Cont -> Val -> Val
appK Cont0 v = v
appK (Cont1 c2 env k) (Num i) =
    appC c2 env (Cont2 i k)
appK (Cont2 i k) (Num j) = appK k (Num (i + j))
appK (Cont3 c2 env k) (Clos env' cb) =
    appC c2 env (Cont4 cb env' k)
appK (Cont4 cb env' k) v = 
    appC cb (v : env') k


testexpr = 
  (App
   (App 
    (App 
      (Lam (Lam (Lam (Plus (App (Var 2) (Var 1)) (App (Var 2) (Var 0))))))
      (App (Lam (Lam (Plus (Var 0) (Var 1))))
           (Val 1)))
    (Val 2)) (Val 3))

instance Show Val where
  show (Num v) = "Num " ++ show v
  show (Clos _ _) = "Closure"

