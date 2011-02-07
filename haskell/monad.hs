
data Exp = Var Int
         | Num Int
         | Plus Exp Exp
         | Lam Exp
         | App Exp Exp deriving Show

data Val = Val Int
         -- | Fun (Val -> Val) deriving Show

type Env = [Val]

eval :: Env -> Exp -> Val
eval env (Num a) = Val a
eval env (Var a) = env !! a
eval env (Plus lhs rhs) = result where Val l = eval env lhs
                                       Val r = eval env rhs
                                       result = l + r

test = (Plus (Num 1) (Num 2))
