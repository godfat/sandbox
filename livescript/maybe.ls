
# Maybe monad implementation:

# unit is called `return` in Haskell
#     unit :: a -> Maybe a
maybe_unit = (x) -> new Just x

# bind is called (>>=) in Haskell
#     bind :: Maybe a -> (a -> Maybe b) -> Maybe b
maybe_bind = (m, f) -> switch m.type
                       case Nothing
                         new Nothing # or simply `m` or `nothing`
                       case Just
                         f(m.value)

class Maybe
  unit:     -> maybe_unit(this)
  bind: (f) -> maybe_bind(this, f)

class Nothing extends Maybe
  type: Nothing

class Just extends Maybe
  (value) -> @value = value
  type: Just

# For convenience
unit    = maybe_unit
just    = (value) -> new Just value
nothing = new Nothing



# Demonstration on how to use Maybe monad:

some-computation = (x) -> unit(x + 1).
              bind (x) -> unit(1 - x)

test = []

test.push (just 1).bind(some-computation) # just -1
test.push (just 5).bind(some-computation) # just -5
test.push  nothing.bind(some-computation) # nothing

console.log(test)
