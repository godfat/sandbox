
module Main where

import Control.Monad (forever)

-- cabal install ansi-terminal
import System.Console.ANSI (setCursorPosition, clearScreen)

-- cabal install reactive-banana
import Reactive.Banana (Event, Moment, stepper)
import Reactive.Banana.Frameworks

help :: IO ()
help = clearScreen >> setCursorPosition 0 0 >> putStrLn "Input a number:"


main :: IO ()
main = do
  help
  (handler, dispatch) <- newAddHandler
  compile (fromAddHandler handler >>= setup) >>= actuate
  forever (getLine >>= dispatch . read)


setup :: Frameworks t => Event t Int -> Moment t ()
setup eInput = do
  eEven <- changes $ stepper True $ fmap even eInput
  eOdd  <- changes $ stepper True $ fmap odd  eInput
  register eInput eEven eOdd


register :: Frameworks t =>
            Event t Int -> Event t Bool -> Event t Bool -> Moment t ()
register eInput eEven eOdd = do
  reactimate $ fmap (const help) eInput

  reactimate $ fmap (\n -> do
                      setCursorPosition 1 0
                      putStrLn ("Even? " ++ show n))
                    eEven

  reactimate $ fmap (\n -> do
                      setCursorPosition 2 0
                      putStrLn (" Odd? " ++ show n))
                    eOdd

  reactimate $ fmap (const clearScreen) eInput
