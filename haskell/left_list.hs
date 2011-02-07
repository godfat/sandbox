
module M where

data LL a = CL (LL a) a | NL deriving Show
data LR a = CR a (LR a) | NR deriving Show

type Token = Char
type Tape = (LL Token, LR Token)

tape :: Tape
tape = (CL (CL (CL NL '1') '2') '3', CR '4' (CR '5' (CR '6' NR)))

shiftL :: Char -> Tape -> Tape
shiftL c (ls`CL`l, _`CR`rs) = (ls, l`CR`(c`CR`rs))

shiftR :: Char -> Tape -> Tape
shiftR c (ls, _`CR`rs) = (ls`CL`c, rs)
