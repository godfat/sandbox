module Exercise where

data Expr = Num Int
          | Var V
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
    show (Var var) = var
    show (Plus lhs rhs) = showsPrec 20 lhs ("+" ++ (showsPrec 20 rhs ""))
    show (Mul  lhs rhs) = showsPrec 10 lhs ("*" ++ (showsPrec 10 rhs ""))

    showsPrec p (Plus l r) rest =
      if p>=20 then
        (show (Plus l r)) ++ rest
      else
        "(" ++ (show (Plus l r)) ++ ")" ++ rest

    showsPrec p (Mul l r) rest =
      if p>=10 then
        (show (Mul l r)) ++ rest
      else
        "(" ++ (show (Mul l r)) ++ ")" ++ rest

    showsPrec _ a rest = (show a) ++ rest

data Val = Val Int
         | Nil
         -- deriving Show

instance Show Val where
  show (Val a) = "Value " ++ (show a)
  show a = "Nil"

deref (Val a) = a

eval' env f lhs rhs = Val (f (deref (eval env lhs)) (deref (eval env rhs)))

eval :: Env -> Expr -> Val
eval env (Num a) = Val a
eval env (Plus lhs rhs) = eval' env (+) lhs rhs
eval env (Mul  lhs rhs) = eval' env (*) lhs rhs
eval env (Var var) = lookUp env var

test_0 = Plus (Num 1) (Num 2)                -- 1 + 2 = Value 3
test_1 = Plus (Num 1) (Plus (Num 2) (Num 3)) -- 1 + 2 + 3 = Value 6
test_2 = Plus (Plus (Num 1) (Num 2)) (Num 3) -- 1 + 2 + 3 = Value 6

test_3 = Mul (Num 2) (Num 3)                 -- 2 * 3 = Value 6
test_4 = Mul (Num 2) (Plus (Num 3) (Num 4))  -- 2 * (3 + 4) = Value 14
test_5 = Mul (Plus (Num 2) (Num 3)) (Num 4)  -- (2 + 3) * 4 = Value 20
test_6 = Mul (Num 2) (Mul (Num 3) (Num 4))   -- 2 * 3 * 4 = Value 24
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

-- begin exercise 3

test_ee_0 = Mul (test_4) (Var "XD")   -- 2*(3+4) * XD
test_ee_1 = Plus (Var "Orz") (test_5) -- Orz + (2+3)*4
test_ee_2 = Mul test_ee_0 test_ee_1   -- 2*(3+4)*XD * (Orz+(2+3)*4)
test_ee_3 = eval test_env_0 test_ee_0 -- 24 * 2 = Value 28
test_ee_4 = eval test_env_0 test_ee_1 -- 20 + 1 = Value 21
test_ee_5 = eval test_env_0 test_ee_2 -- 28 * 21 = Value 588
