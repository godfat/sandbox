fib = 0 : 1 : [x+y | (x, y) <- zip fib (tail fib)]
combos = [(x, y) | x <- [0..1], y <- [2..3]]

{-


fib = [0, 1] + List[lambda{|x,y|}]
combos = List[->(x,y){[x,y]}, 0..1, 2..3]

-}
