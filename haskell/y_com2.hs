
fix :: (a -> a) -> a
fix f = f (fix f)

fact :: Num a => (a -> a) -> a -> a
fact = \self x -> if x == 0 then 1 else x * self (x-1)

newtype Mu a = Roll{ unroll :: Mu a -> a }

y :: (a -> a) -> a
y = \f -> (\x -> f (unroll x x)) (Roll (\x -> f (unroll x x)))
