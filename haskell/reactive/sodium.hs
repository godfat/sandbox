
module Main where

import Control.Monad (forever)

-- cabal install ansi-terminal
import System.Console.ANSI (setCursorPosition, clearScreen)

-- cabal install sodium
import FRP.Sodium (Event, Reactive, newEvent, sync, changes, hold, listen)

main :: IO ()
main = do
  help
  (event, dispatch) <- sync newEvent
  -- Why this warning without `_ <-' ?
  -- A do-notation statement discarded a result of type IO ().
  _ <- sync $ setup event
  forever (getLine >>= sync . dispatch . read)


help :: IO ()
help = clearScreen >> setCursorPosition 0 0 >> putStrLn "Input a number:"


setup :: Event Int -> Reactive (IO ())
setup eInput = do
  eEven <- fmap changes $ hold True (fmap even eInput)
  eOdd  <- fmap changes $ hold True (fmap odd  eInput)
  register eInput eEven eOdd


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
