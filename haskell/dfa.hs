
import Data.List (find, lookup)
import Data.Char (digitToInt)

import Control.Monad (mfilter, foldM, (=<<))

data DFA s a = DFA {
    start  ::  s
  , accept :: [s]
  , delta  :: [(s, [(a, s)])]} deriving (Show, Eq)

input :: DFA Char Int
input = DFA{ start  =  'a'
           , accept = ['b', 'c']
           , delta  = [('a', [(0, 'b'), (1, 'c')])
                      ,('b', [(0, 'a'), (1, 'b')])
                      ,('c', [(0, 'a'), (1, 'c')])]}

process'dfa :: (Eq s, Eq a) => DFA s a -> [a] -> Maybe s
process'dfa input     [] = find (== start input) (accept input)
process'dfa input (x:xs) = do
    table <- lookup (start input) (delta input)
    state <- lookup x table
    process'dfa input{ start = state } xs

fromString = map digitToInt

test0 = process'dfa input (fromString "01001")  -- Just 'b'
test1 = process'dfa input (fromString "010010") -- Nothing

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

type DFA' s a = (s, [s], [(s, [(a, s)])])

process'dfa' :: (Eq s, Eq a) => DFA' s a -> [a] -> Maybe s
process'dfa' (start, accept, delta) xs =
    mfilter (`elem` accept) $ foldM step start xs
    where step state x = lookup x =<< lookup state delta

input' = (start input, accept input, delta input)

test0' = process'dfa' input' (fromString "01001")  -- Just 'b'
test1' = process'dfa' input' (fromString "010010") -- Nothing
