
import System.Posix (sleep)
import Control.Concurrent (forkIO)
import Control.Concurrent.STM (atomically, retry, TVar, STM,
                               newTVar, readTVar, writeTVar)

main = do
  i <- atomically (newTVar 0)
  forkIO $ do
    sleep 1
    atomically (writeTVar i 1)
  putStrLn "Waiting..."
  atomically (nonzero i) >>= print
  putStrLn "Done."

nonzero :: TVar Integer -> STM Integer
nonzero var = do
  i <- readTVar var
  if i == 0 then
    retry
  else
    return i
