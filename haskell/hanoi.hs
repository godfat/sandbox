
module Main where

data Graph a b c = Graph (a, b, c) deriving Show

A = 'A'
B = 'B'
C = 'C'

hanoi 0 = Graph (A, B, C)
hanoi n = hanoi (n-1) Graph (Graph (a,c,b), Graph (c,b,a), Graph (b,a,c))
