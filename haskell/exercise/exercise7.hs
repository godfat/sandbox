module Exercise where

data Expr = Num Int
          | Var V
          | Plus Expr Expr
          | Mul Expr Expr
          | Lam V Expr
          | Ram V Expr
          | App Expr Expr
          | AppName Expr Expr
          | NA
          -- deriving Eq
          -- deriving Show

instance Show Expr where
    show (Num a) = show a
    show (Var var) = var
    show (Plus lhs rhs) = showsPrec 20 lhs ("+" ++ (showsPrec 20 rhs ""))
    show (Mul  lhs rhs) = showsPrec 10 lhs ("*" ++ (showsPrec 10 rhs ""))
    show (Lam arg body) = "(\\" ++ arg ++ "->" ++ (show body) ++ ")"
    show (App fun  arg) = (show fun) ++ " " ++ (show arg)
    show NA = "NA"

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

    showsPrec p (App a b) rest =
      if p>=5 then
        (show (App a b)) ++ rest
      else
        "(" ++ (show (App a b)) ++ ")" ++ rest

    showsPrec _ a rest = (show a) ++ rest

data Val = Val Int
         | Nil
         | Fun (Val -> Val)
         | FunName (Expr -> Val)
         -- | FunName (Expr -> Env -> Val)
         -- deriving Eq
         -- deriving Show

instance Eq Val where
  Nil == Nil = True
  _ == Nil = False
  Nil == _ = False
  

instance Show Val where
  show (Val a) = "Value " ++ (show a)
  show a = "Nil"

deref (Val a) = a

eval' env f lhs rhs = Val (f (deref (eval env lhs)) (deref (eval env rhs)))

eval :: Env -> Expr -> Val
eval env (Num a) = Val a
eval env (Plus lhs rhs) = eval' env (+) lhs rhs
eval env (Mul  lhs rhs) = eval' env (*) lhs rhs
eval env (Var var)      = lookUp env var
eval env (Lam arg body) = Fun (\x -> eval (add (v_var arg x) env) body)
-- eval env (Ram arg body) = FunName (\x outer_env -> eval (add (e_var arg x) (env ++ outer_env)) body)
eval env (Ram arg body) = FunName (\x -> eval (add (e_var arg x) env) body)
eval env (App fun arg) = let Fun f = eval env fun in f (eval env arg)
-- eval env (AppName fun arg) = let FunName f = eval env fun in f arg env
eval env (AppName fun arg) = let FunName f = eval env fun in f arg

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
type VPair = (V, (Val, Expr))
type Env = [VPair]

empty :: Env
empty = []

add :: VPair -> Env -> Env
add pair env = pair : env

v_var :: V -> Val -> VPair
v_var v val = (v, (val, NA))

e_var :: V -> Expr-> VPair
e_var v exp = (v, (Nil, exp))

lookUp :: Env -> V -> Val
lookUp []  v = Nil
lookUp env v =
  let ele = head env
      var = fst ele
      val = fst (snd ele)
  in
      if v == var then     -- match
        if val == Nil then -- let's eval it... but how to store back to val?
          eval env (snd (snd ele))
        else
          val
      else
        lookUp (tail env) v


test_env_0 = (add (v_var "Orz" (Val 1)) (add (v_var "XD" (Val 2)) empty))
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

-- begin exercise 5

test_e5_0 = eval empty (Plus (Num 10) (App (Lam "x" (Plus (Var "x") (Num 1))) (Num 10))) -- Value 21
test_e5_1 = eval empty (Mul (App (Lam "x" (Plus (Var "x") (Num 1))) (Num 10)) (Num 10))  -- Value 110
test_e5_2 = eval test_env_0 (App (Lam "Orz" (Mul (Num 2) (Var "Orz"))) (Num 5))          -- Value 10
test_e5_3 = eval test_env_0 (App (Lam "XD" (Mul (Num 2) (Var "Orz"))) (Num 5))           -- Value 2
test_e5_4 = eval test_env_0 (App (Lam "x" (Mul (Var "x") (Var "XD"))) (Num 3))           -- Value 6
test_e5_5 = eval test_env_0 (App (Lam "x" (Plus (Var "XD") (Var "x"))) (Mul (Num 3) (Var "XD")))-- Value 8

-- begin exercise 7

-- data R a = R (R a->a)
-- inf = (\(R x) -> x (R x)) (R (\(R x) -> x (R x)))
inf = (App (Lam "x" (App (Var "x") (Var "x"))) (Lam "x" (App (Var "x") (Var "x"))))

test_e7_0 = eval empty (AppName (Ram "x" (Num 29)) inf) -- Value 29
test_e7_1 = eval empty (App     (Lam "x" (Num 29)) inf) -- should have been inf... Orz

test_e7_2 = eval test_env_0 (AppName (Ram "x" (Var "Orz")) (Var "Orz")) -- Value 1
test_e7_3 = eval test_env_0 (App     (Lam "x" (Var "Orz")) (Var "Orz")) -- Value 1

test_e7_4 = eval test_env_0 (AppName (Ram "x" (Var "x")) (Var "Orz")) -- Value 1
test_e7_5 = eval test_env_0 (App     (Lam "x" (Var "x")) (Var "Orz")) -- Value 1

test_e7_6 = eval test_env_0 (AppName (Ram "XD" (Var "XD")) (Num 29)) -- Value 29
test_e7_7 = eval test_env_0 (App     (Lam "XD" (Var "XD")) (Num 29)) -- Value 29
