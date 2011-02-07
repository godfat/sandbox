module Exercise where

data Val = Val Int
         | Nil
         -- deriving Show

deref (Val a) = a

instance Show Val where
  show (Val a) = "Value " ++ (show a)
  show a = "Nil"

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

type E = Env -> Val

num :: Int -> E
num n = \env -> Val n

operate :: (Int -> Int -> Int) -> E -> E -> E
operate f x y = \env -> let Val v1 = x env
                            Val v2 = y env
                        in  Val (f v1 v2)

plus :: E -> E -> E
plus x y = operate (+) x y

mult :: E -> E -> E
mult x y = operate (*) x y

var :: V -> E
var name = \env -> lookUp env name

test_e4_0 = plus (num 1) (num 2)     empty      -- Val 3
test_e4_1 = plus (var "Orz") (num 2) test_env_0 -- Val 3
test_e4_2 = mult (num 3) (var "XD")  test_env_0 -- Val 6
