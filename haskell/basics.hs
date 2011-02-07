
type Var = String

data Exp = Val Int
         | Var Int
         | Plus Exp Exp
         | Lam Exp 
         | App Exp Exp deriving Show

data Val = Num Int
         | Clos Env Exp deriving Show

type Cont = Val -> Val

type Env = [Val]

-- eval, in CPS style. Why CPS?


eval :: Env -> Exp -> Cont -> Val
eval _ (Val n) k = k (Num n)
eval env (Var n) k = k (env !! n)
eval env (Plus e1 e2) k = 
   eval env e1 (\(Num i) -> eval env e2 (\(Num j) -> k (Num (i + j))))
eval env (Lam e) k =
   k (Clos env e)
eval env (App e1 e2) k =
   eval env e1 (\(Clos env' body) ->
      eval env e2 (\v -> eval (v : env') body k))

-- testexpr = (\f -> \a -> \b -> f a + f b) ((\c -> (\d -> c + d)) 1) 2 3

testexpr = 
  (App
   (App 
    (App 
      (Lam (Lam (Lam (Plus (App (Var 2) (Var 1)) (App (Var 2) (Var 0))))))
      (App (Lam (Lam (Plus (Var 0) (Var 1))))
           (Val 1)))
    (Val 2)) (Val 3))



