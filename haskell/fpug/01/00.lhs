
Define the module name. This could be omitted if you're only testing it
in GHCi. When compiling a Haskell program in GHC, the starting point of
the program would be the main function inside the Main module.

> module Main where

Algebraic Datatypes -- so we define a datatype called `Expression' and
it would be either a `Literal' or a `Plus'. A literal would contain an
`Integer', and a Plus would contain two more other `Expression'.

Here Literal and Plus is called the constructors of Expression,
by using the two constructors, we can construct a data typed with
Expression.

Some examples:

one = Literal 1
onePlusTwo = Plus (Literal 1) (Literal 2)
onePlusTwoPlusThree = Plus (Plus (Literal 1) (Literal 2)) (Literal 3)

> data Expression = Literal Integer
>                 | Plus Expression Expression

The `evaluate' function is a function which takes an Expression and
then evaluate it into a result. By result, I mean it could be anything.
Here we simply evaluate the expression into an integer, because that's
all we have now.

Pattern matching -- here we give `evaluate' two definitions, each of them
is a partial function, meaning that it's only defined given a certain range
of arguments. Put those partial functions together, we have a total function,
if it covers all of its valid argument. Here the argument is typed
`Expression', and it could either be a Literal or a Plus, and we both
covered them, so `evaluate' is total here. This might not be the formal
definition, but you get the idea.

Whenever `evaluate' is called, it would match the pattern of the argument
according to the definition of `Expression', picking the corresponding
partial function and call it.

> evaluate :: Expression -> Integer
> evaluate (Literal i)        = i
> evaluate (Plus expr0 expr1) = evaluate expr0 + evaluate expr1

If we got a Literal, all we have to do is return the Integer inside.
If we got a Plus, we need to evaluate both of the expressions inside
the Plus, and then add them together to get the desired result.
This way, data like this could be evaluate to 6:

Plus (Plus (Literal 1) (Literal 2)) (Literal 3)
      ^^^^^^^^^^^^^^^^^^^^^^^expr0   ^^^^expr1

---------------------------------------------------------------------------

> main = print [test0, test1, test2]

> test0 = evaluate (Literal 1)
> test1 = evaluate (Plus (Literal 1) (Literal 2))
> test2 = evaluate (Plus (Plus (Literal 1) (Literal 2)) (Literal 3))
