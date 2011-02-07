
> import Prelude hiding (foldr)

How to use foldr to implement foldl' ?
foldl' (flip init and list of foldl) definition:

> foldl' :: (b -> a -> b) -> [a] -> b -> b
> foldl' _ []     e = e
> foldl' f (x:xs) e = foldl' f xs (f e x)

What came to my mind first would be:

> foldl'0 :: (b -> a -> b) -> [a] -> b -> b
> foldl'0 f = flip (foldr (flip f))

But what we want would be started with foldr like (foldr ...)
instead of (flip (foldr ...)). We could use fold fusion theorem
to fuse flip into foldr, but... I'll just skip that because
I don't know fold fusion well...

Here's foldr definition:

> foldr :: (a -> b -> b) -> b -> [a] -> b
> foldr _ m []     = m
> foldr g m (x:xs) = g x (foldr g m xs)

So... if we see (foldr g m) as h, foldr could be written:

  h [] = m
  h (x : xs) = g x (h xs)

That is:

  h = foldr g m

Let's start trying to derive foldl' definition to
match the pattern mentioned above.

First, move e to right then we get m = id,
and h = foldl' f. Next we should find out g.

> foldl'1 :: (b -> a -> b) -> [a] -> b -> b
> foldl'1 _ []     = id
> foldl'1 f (x:xs) = \e -> (foldl'1 f xs) (f e x)

Flip f to try to extract e, then we could do eta-reduction.

> foldl'2 :: (b -> a -> b) -> [a] -> b -> b
> foldl'2 _ []     = id
> foldl'2 f (x:xs) = \e -> (foldl'2 f xs) ((flip f) x e)

Use compose to extract e.
(Point-free style exercise really helps here.)

> foldl'3 :: (b -> a -> b) -> [a] -> b -> b
> foldl'3 _ []     = id
> foldl'3 f (x:xs) = \e -> ((foldl'3 f xs) . (flip f) x) e

Doing eta-reduction:

> foldl'4 :: (b -> a -> b) -> [a] -> b -> b
> foldl'4 _ []     = id
> foldl'4 f (x:xs) = (foldl'4 f xs) . (flip f) x

Then we find that (h xs) is on the left, but we need it right.
Flip compose to try to put (h xs) right.

> foldl'5 :: (b -> a -> b) -> [a] -> b -> b
> foldl'5 _ []     = id
> foldl'5 f (x:xs) = flip (.) ((flip f) x) (foldl'5 f xs)

Here we get (g x), but the real x here is deep inside.
Try to extract x using compose again to match real (g x):

> foldl'6 :: (b -> a -> b) -> [a] -> b -> b
> foldl'6 _ []     = id
> foldl'6 f (x:xs) = ((flip (.)) . (flip f)) x (foldl'6 f xs)

Then we get g = ((flip (.)) . (flip f))
Applying m and g to h:

> foldl'7 :: (b -> a -> b) -> [a] -> b -> b
> foldl'7 f = foldr ((flip (.)) . (flip f)) id

Pretty cool... I can imagine init value of foldr should
be a function, since we would need some placeholders in
foldr, that means it would be more higher order to get
type checked. But I don't know it is an id function.
The flip"s" inside the f of foldr are so complex too...

I wonder if anyone could come up with this without deriving?

And... I am wondering about why foldl cannot be applied
with infinite list again. If foldl could be easily written
in foldr, it should be fine to be applied with infinite list
as well. Is it runtime performance implementation issue?
