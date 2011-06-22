
-- http://computationalthoughts.blogspot.com/2008/03/some-examples-of-software-transactional.html

import System.Random (newStdGen, randomR, StdGen)

import Control.Monad (replicateM)
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.STM (atomically, retry, TVar, STM,
                               newTVar, readTVar, writeTVar)

data Fork = Free | Hold deriving (Show, Eq)

-- WriterT [String] IO Int

main = do
  gen   <- newStdGen >>= \g -> atomically (newTVar g)
  forks <- atomically (replicateM 5 (newTVar Free))
  buffer <- atomically (newTVar [])
  for [0..4] `at` \i ->
    forkIO `at` philosopher i buffer gen
                  (forks !! i) (forks !! ((i + 1) `mod` 5))
  monitor buffer

philosopher :: Int -> TVar [String] -> TVar StdGen ->
               TVar Fork -> TVar Fork -> IO ()
philosopher n buffer tgen fork0 fork1 = do
  delay <- atomically `at` elapseSomeTime tgen
  threadDelay delay
  atomically `at` do
    tell buffer ("Philosopher " ++ show n ++ " is eating.")

  atomically `at` do
    eat   fork0
    eat   fork1

  delay <- atomically `at` elapseSomeTime tgen
  threadDelay delay
  atomically `at` do
    tell buffer ("Philosopher " ++ show n ++ " is thinking.")

  atomically `at` do
    think fork0
    think fork1

  philosopher n buffer tgen fork0 fork1

--

elapseSomeTime :: TVar StdGen -> STM Int
elapseSomeTime tgen = do
  gen <- readTVar tgen
  let (delay, gen') = randomR (1, 1000) gen
  writeTVar tgen gen'
  return delay

think :: TVar Fork -> STM ()
think tfork = do
  fork <- readTVar tfork
  case fork of
    Free -> undefined
    Hold -> writeTVar tfork Free

eat :: TVar Fork -> STM ()
eat tfork = do
  fork <- readTVar tfork
  case fork of
    Free -> writeTVar tfork Hold
    Hold -> retry

--

monitor :: TVar [String] -> IO ()
monitor buffer = do
  sentences <- atomically (flush buffer)
  for sentences putStrLn
  monitor buffer

tell :: TVar [String] -> String -> STM ()
tell var sentence = do
  buffer <- readTVar var
  writeTVar var (buffer ++ [sentence])

flush :: TVar [String] -> STM [String]
flush var = do
  buffer <- readTVar var
  case buffer of
    [] -> retry
    _  -> do
      writeTVar var []
      return buffer

--

for :: (Monad m) => [a] -> (a -> m b) -> m ()
for = flip mapM_

infixr 0 `at`
at :: (a -> b) -> a -> b
f `at` x = f x
