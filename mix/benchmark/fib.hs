
import Control.Monad
import Text.Printf

fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

main = forM_ [0..34] $ \i ->
            printf "n=%d => %d\n" i (fib i)
