
-- Defunctionalising eval

type Var = String

data Exp = Val Int
         | Var Int
         | Plus Exp Exp
         | Lam Exp 
         | App Exp Exp  deriving Show

data Val = Num Int
         | Clos Env Compt deriving Show

type Env = [Val]

type Compt = [Inst]

data Cont = Cont0
          | Cont1 Compt Env Cont
          | Cont2 Int Cont
          | Cont3 Compt Env Cont     
          | Cont4 Compt Env Cont  deriving Show

data Inst = Lit Int 
          | Access Int
          | Close Compt
          | Push1 Compt
          | Push2 Compt   deriving Show

eval :: Exp -> Compt
eval (Val m) = [Lit m]
eval (Var n) = [Access n] 
eval (Plus e1 e2) = Push1 (eval e1) : eval e2
eval (Lam e) = [Close (eval e)]
eval (App e1 e2) = Push2 (eval e1) : eval e2

appC :: [Inst] -> Env -> Cont -> Val
appC [Lit m] env k = appK k (Num m)
appC [Access n] env k = appK k (env !! n)
appC [Close is] env k = appK k (Clos env is)
appC (Push1 is1 : is2) env k = appC is1 env (Cont1 is2 env k)
appC (Push2 is1 : is2) env k = appC is1 env (Cont3 is2 env k)

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

