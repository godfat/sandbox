
# List monad implementation:

# unit is called `return` in Haskell
#     unit :: a -> Maybe a
list_unit = (x) -> cons(x, empty)

# bind is called (>>=) in Haskell
#     bind :: [a] -> (a -> [b]) -> [b]
list_bind = (m, f) -> switch m.type
                      case Empty
                        empty
                      case Cons
                        concat(map(f, m))

class List
  unit:     -> list_unit(this)
  bind: (f) -> list_bind(this, f)

class Empty extends List
  type: Empty

class Cons extends List
  (value, list) ->
    @value = value
    @list  = list
  type: Cons

# append :: [a] -> [a] -> [a]
append = (xs, ys) -> switch xs.type
                     case Empty
                       ys
                     case Cons
                       cons(xs.value, append(xs.list, ys))

# concat :: [[a]] -> [a]
concat = (xss) -> switch xss.type
                  case Empty
                    empty
                  case Cons
                    append(xss.value, concat(xss.list))

# map :: (a -> b) -> [a] -> [b]
map = (f, xs) -> switch xs.type
                 case Empty
                   empty
                 case Cons
                   cons(f(xs.value), map(f, xs.list))

# For convenience
unit  = list_unit
empty = new Empty
cons  = (value, list) -> new Cons(value, list)



# Demonstration on how to use List monad:

some-computation = (x) -> unit(x + 1).
              bind (x) -> unit(1 - x)

test = []

test.push (cons(1, empty)).bind(some-computation) # [-1]
test.push (cons(5, empty)).bind(some-computation) # [-5]
test.push            empty.bind(some-computation) # empty



# Let's see list comprehension:

list = cons(0, cons(1, cons(2, cons(3, cons(4, empty))))) # [0, 1, 2, 3, 4]



# [x*2 | x <- [0..5], x % 2 == 0]                         # [0, 4, 8]
test.push list.bind((x) -> if x % 2 == 0 then unit(x * 2) else empty)
# Also equivalent to this in Haskell:
# [0..5] >>= \x -> if mod x 2 == 0 then return (x * 2) else []
# or with do notation, a syntactic sugar for using monad:
# do{ x <- [0..5]; if mod x 2 == 0 then return (x * 2) else [] }



# [x + y | x <- [0..1], y <- [1..2]]                      # [1, 2, 2, 3]
test.push((cons(0, cons(1, empty))).
     bind((x) -> (cons(1, cons(2, empty))).
     bind((y) -> unit(x + y))))
# Also equivalent to this in Haskell:
# [0..1] >>= \x -> [1..2] >>= \y -> return (x + y)
# or with do notation, a syntactic sugar for using monad:
# do{ x <- [0..1]; y <- [1..2]; return (x + y) }



# powerset :: [a] -> [[a]]
powerset = (xs) -> switch xs.type
                   case Empty
                     cons(empty, empty)
                   case Cons
                     cons(true, cons(false, empty)).
                     bind((take) -> powerset(xs.list).
                     bind((ys)   -> if take then unit(cons(xs.value, ys))
                                    else         unit(ys)))
# Also equivalent to this in Haskell:
# powerset []     = [[]]
# powerset (x:xs) = [True, False] >>= \take -> powerset xs
#                                 >>= \ys   -> if take then return (x:ys)
#                                              else         return ys
# or with do notation, a syntactic sugar for using monad:
# powerset []     = [[]]
# powerset (x:xs) = do
#   take <- [True, False]
#   ys   <- powerset xs
#   if take then return (x:ys)
#   else         return ys

# [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]]
test.push(powerset(cons(1, cons(2, cons(3, empty)))))



console.log(require('util').inspect(test, false, null))

# So as you can see:
#
# * Operator overloading matters.
# * Syntactic sugar matters.
#
# We might not gain too much using (Haskell's) monad in other languages!
