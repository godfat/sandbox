module Exercise where

data Expr = Num Int
          | Plus Expr Expr
          | Mul Expr Expr
          -- deriving Show

instance Show Expr where
  -- show (Num a) = show a
  -- show (Plus lhs rhs) = "(" ++ (show lhs) ++ "+" ++ (show rhs) ++ ")"
  -- show (Mul lhs rhs) = "(" ++ (show lhs) ++ "*" ++ (show rhs) ++ ")"
  -- let
    -- p_plus =  0
    -- p_mul  = -1
  -- in
    show (Num a) = show a
    show (Plus lhs rhs) = showsPrec 20 lhs ("+" ++ (showsPrec (-20) rhs ""))
    show (Mul  lhs rhs) = showsPrec 10 lhs ("*" ++ (showsPrec (-10) rhs ""))

    showsPrec p (Plus l r) rest =
      if (p>0 && p>=20) || (p<0 && (-p)>=20) then
        (show (Plus l r)) ++ rest
      else
        "(" ++ (show (Plus l r)) ++ ")" ++ rest

    showsPrec p (Mul l r) rest =
      if (p>0 && p>=10) || (p<0 && (-p)>=10) then
        (show (Mul l r)) ++ rest
      else
        "(" ++ (show (Mul l r)) ++ ")" ++ rest

    showsPrec _ (Num a) rest = (show a) ++ rest

data Val = Val Int
         | Nil
         -- deriving Show

instance Show Val where
  show (Val a) = "Value " ++ (show a)
  show a = "Nil"

deref (Val a) = a

-- eval_apply f (Num a) rhs = Val (f a (deref.eval $ rhs))
eval_apply f  lhs    rhs = Val (f (deref.eval $ lhs) (deref.eval $ rhs))

eval :: Expr -> Val
eval (Num a) = Val a

eval (Plus lhs rhs) = eval_apply (+) lhs rhs
eval (Mul  lhs rhs) = eval_apply (*) lhs rhs

-- eval (Plus (Num a) rhs) = Val ((+) a (deref.eval $ rhs))
-- eval (Mul  (Num a) rhs) = Val ((*) a (deref.eval $ rhs))
-- eval (Plus lhs rhs) = Val ((+) (deref.eval $ lhs) (deref.eval $ rhs))
-- eval (Mul  lhs rhs) = Val ((*) (deref.eval $ lhs) (deref.eval $ rhs))

test_0 = Plus (Num 1) (Num 2)                -- 1 + 2 = Value 3
test_1 = Plus (Num 1) (Plus (Num 2) (Num 3)) -- 1 + (2 + 3) = Value 6
test_2 = Plus (Plus (Num 1) (Num 2)) (Num 3) -- 1 + 2 + 3 = Value 6

test_3 = Mul (Num 2) (Num 3)                 -- 2 * 3 = Value 6
test_4 = Mul (Num 2) (Plus (Num 3) (Num 4))  -- 2 * (3 + 4) = Value 14
test_5 = Mul (Plus (Num 2) (Num 3)) (Num 4)  -- (2 + 3) * 4 = Value 20
test_6 = Mul (Num 2) (Mul (Num 3) (Num 4))   -- 2 * (3 * 4) = Value 24
test_7 = Mul (Mul (Num 2) (Num 3)) (Num 4)   -- 2 * 3 * 4 = Value 24

-- begin exercise 2

type V = String
type Env = [(V, Val)]

empty :: Env
empty = []

add :: (V, Val) -> Env -> Env
add pair env = pair : env

lookUp :: Env -> V -> Val
lookUp [] v = Nil
lookUp env v =
  if v == fst (head env) then
    snd (head env)
  else
    lookUp (tail env) v

test_env_0 = (add ("Orz", Val 1) (add ("XD", Val 2) empty))
test_env_1 = lookUp test_env_0 "Orz"
test_env_2 = lookUp test_env_0 "XD"
test_env_3 = lookUp test_env_0 "Nil"
