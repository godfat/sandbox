
module Main where

import Control.Monad (forever)

-- cabal install ansi-terminal
import System.Console.ANSI (setCursorPosition, clearScreen)

-- cabal install sodium
import FRP.Sodium (Event, Reactive, newEvent, sync, changes, hold, listen)

help :: IO ()
help = clearScreen >> setCursorPosition 0 0 >> putStrLn "Input a number:"


main :: IO ()
main = do
  help
  (eInput, dispatch) <- sync newEvent
  -- Why this warning without `_ <-' ?
  -- A do-notation statement discarded a result of type IO ().
  _ <- sync $ setup eInput
  forever (getLine >>= sync . dispatch . read)


-- setup data dependency
setup :: Event Int -> Reactive (IO ())
setup eInput = do
  eEven <- fmap changes $ hold True (fmap even eInput)
  eOdd  <- fmap changes $ hold True (fmap odd  eInput)
  register eInput eEven eOdd


-- register event handlers
register :: Event Int -> Event Bool -> Event Bool -> Reactive (IO ())
register eInput eEven eOdd = do
  listen eInput (const help)

  listen eEven  (\n -> do
                  setCursorPosition 1 0
                  putStrLn ("Even? " ++ show n))


  listen eOdd   (\n -> do
                  setCursorPosition 2 0
                  putStrLn (" Odd? " ++ show n))

  listen eInput (const clearScreen)
