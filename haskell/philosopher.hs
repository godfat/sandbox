
-- http://computationalthoughts.blogspot.com/2008/03/some-examples-of-software-transactional.html

import System.Random (newStdGen, randomR)
import System.Posix (sleep)

import Control.Monad (replicateM)
import Control.Concurrent (forkIO)
import Control.Concurrent.STM (atomically, retry, TVar, STM,
                               newTVar, readTVar, writeTVar)

data Fork = Free | Hold deriving (Show, Eq)
type TFork = TVar Fork

-- WriterT [String] IO Int

main = do
  gen   <- newStdGen
  forks <- atomically forksSTM
  for [0..4] `at` \i ->
    forkIO `at` philosopher (forks !! i) (forks !! ((i + 1) `mod` 5))

forksSTM :: STM [TFork]
forksSTM = replicateM 5 newForkSTM

newForkSTM :: STM TFork
newForkSTM = newTVar Free

philosopher :: TFork -> TFork -> IO ()
philosopher fork0 fork1 = do
  atomically `at` do
    eat   fork0
    eat   fork1

  atomically `at` do
    think fork0
    think fork1

  philosopher fork0 fork1

--

think :: TFork -> STM ()
think tfork = do
  fork <- readTVar tfork
  case fork of
    Free -> retry
    Hold -> writeTVar tfork Hold

eat :: TFork -> STM ()
eat tfork = do
  fork <- readTVar tfork
  case fork of
    Free -> writeTVar tfork Free
    Hold -> retry

--

for :: (Monad m) => [a] -> (a -> m b) -> m ()
for = flip mapM_

infixr 0 `at`
at :: (a -> b) -> a -> b
f `at` x = f x
