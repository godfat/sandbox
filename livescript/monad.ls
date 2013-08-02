
# Please check maybe.ls and then list.ls first
# https://github.com/godfat/sandbox/blob/master/livescript/maybe.ls
# https://github.com/godfat/sandbox/blob/master/livescript/list.ls

# So to put them together, we need to make unit and bind polymorphic.

Monad =
  unit: void
  bind: void

# Maybe monad implementation:

# unit is called `return` in Haskell
#     unit :: a -> Maybe a
maybe_unit = (x) -> new Just x

# bind is called (>>=) in Haskell
#     bind :: Maybe a -> (a -> Maybe b) -> Maybe b
maybe_bind = (m, f) -> switch m.type
                       case Nothing
                         nothing
                       case Just
                         f(m.value)

class Maybe implements Monad
  unit:     -> maybe_unit(this)
  bind: (f) -> maybe_bind(this, f)
  kind: Maybe

class Nothing extends Maybe
  type: Nothing

class Just extends Maybe
  (value) -> @value = value
  type: Just

# For convenience
nothing = new Nothing
just    = (value) -> new Just value

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

class List implements Monad
  unit:     -> list_unit(this)
  bind: (f) -> list_bind(this, f)
  kind: List

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
empty = new Empty
cons  = (value, list) -> new Cons(value, list)






# Here we make unit and bind polymorphic:
#
# However we need to do some little hack to this polymorphic
# unit function which is not required in Haskell. That is,
# we need to give it a hint what monad we would like it to return...
# This might be needed for all those dynamic typing languages!
# As we don't have static type information for us to infer from.
# We need to see the return type to decide which monomorphic function
# we would like to use. Here it would be either maybe_unit or list_unit.
# They have the same argument type but different return types.
#
# As far as I know, this is not possible in a dynamic typing language
# because which function is called is depending on arguments, not
# returns, but we need to decide which monomorphic function to call
# depending on return types, which there's no way to predict unless you
# explicitly give it a hint. Thus we give it a hint as the first argument.
# Note that this is not required in Haskell, as Haskell could infer the
# return type and find the desired monomorphic function for us.
#
# unit :: (Monad m) => m -> a -> m a
unit = (m, x) -> switch m
                 case Maybe
                   maybe_unit(x)
                 case List
                   list_unit(x)

# bind :: (Monad m) => m a -> (a -> m b) -> m b
bind = (m, f) -> switch m.kind
                 case Maybe
                   maybe_bind(m, f)
                 case List
                   list_bind(m, f)



# Let's try our polymorphic unit and bind
                        # --> means it's a curried function
some-computation = (m, x) --> unit(m, x + 1).
                 bind (x)  -> unit(m, 1 - x)

test = []

test.push         (just 1).bind(some-computation(Maybe)) # just -1
test.push          nothing.bind(some-computation(Maybe)) # nothing
test.push (cons(1, empty)).bind(some-computation(List )) # [-1]
test.push            empty.bind(some-computation(List )) # empty

console.log(test)



# You might say... since we already know what the monad is in bind,
# we could pass the information to the bound function, then we don't
# have to give it the hint. Well, yes, but then we would need to
# modify the original bind definition, and make every bound functions
# take an additional monad information. As implemented:

#     bind :: (Monad m) => Maybe a -> (m -> a -> Maybe b) -> Maybe b
maybe_bind = (m, f) -> switch m.type
                       case Nothing
                         nothing
                       case Just
                         f(m, m.value) # previously it's f(m.value)

#     bind :: (Monad m) => [a] -> (m -> a -> [b]) -> [b]
list_bind = (m, f) -> switch m.type
                      case Empty
                        empty
                      case Cons
                        concat(map(((x) -> f(m, x)), m))
                        # previously it's concat(map(f, m))

# unit :: (Monad m) => m -> a -> m a
unit = (m, x) -> switch m.kind # previously it's simply m
                 case Maybe
                   maybe_unit(x)
                 case List
                   list_unit(x)

# Let's try our new polymorphic unit and bind
some-computation = (m, x) -> unit(m, x + 1).
              bind (m, x) -> unit(m, 1 - x)

test = []

test.push         (just 1).bind(some-computation) # just -1
test.push          nothing.bind(some-computation) # nothing
test.push (cons(1, empty)).bind(some-computation) # [-1]
test.push            empty.bind(some-computation) # empty

console.log(test)

# Which implementation do you prefer?
