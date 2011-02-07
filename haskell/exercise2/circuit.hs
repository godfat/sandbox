
module Circuit where

type Wire = [Bool]

delay :: Wire -> Wire
delay xs = False : xs

gate :: (Bool -> Bool -> Bool) -> Wire -> Wire -> Wire
gate way xs ys = zipWith way xs ys

andG :: Wire -> Wire -> Wire
andG = gate (&&)

orG :: Wire -> Wire -> Wire
orG = gate (||)

xorG :: Wire -> Wire -> Wire
xorG = gate (/=)

half_adder :: Bool -> Bool -> (Bool, Bool)
half_adder a b = (a && b, a /= b)

full_adder :: Bool -> Bool -> Bool -> (Bool, Bool)
full_adder a b c = ((a && b) || (c && (a /= b)), (a /= b) /= c)

ripple_carry_adder_3bits :: Bool -> Bool -> Bool -> Bool -> Bool -> Bool ->
                                   (Bool, Bool, Bool, Bool)
ripple_carry_adder_3bits a3 b3 a2 b2 a1 b1 =
    (fst o3, snd o3, snd o2, snd o1) where
        o1 = half_adder a1 b1
        o2 = full_adder a2 b2 (fst o1)
        o3 = full_adder a3 b3 (fst o2)
