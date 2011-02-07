
main :: IO ()
main = do
          putStr "what's your name?>"
          name <- getLine
          putStr ("hi, " ++ name ++ ".\n")
