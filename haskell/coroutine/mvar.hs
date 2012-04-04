
-- cabal install monad-coroutine

import Control.Concurrent.MVar (MVar, newMVar, readMVar, tryTakeMVar, putMVar)
import Control.Monad.Trans (lift)
import Control.Monad.Coroutine (Coroutine, resume)
import Control.Monad.Coroutine.SuspensionFunctors (Yield(Yield), yield)

type Fiber = Coroutine (Yield ()) IO ()

fiber :: MVar Int -> Fiber
fiber i = lift (tryTakeMVar i) >>= \t ->
            case t of
              Nothing -> yield () >> fiber i
              Just t  -> do
                           yield ()
                           lift (putMVar i (t + 1))
                           return ()

schedule :: [Fiber] -> IO ()
schedule []     = return ()
schedule (f:fs) = resume f >>= \t -> case t of
                    Left (Yield _ f') -> schedule (fs ++ [f'])
                    Right _           -> schedule  fs

main = do
  i <- newMVar 0
  let a = fiber i
      b = fiber i in do
      readMVar i >>= print -- 0
      schedule [a, b]
      readMVar i >>= print -- 2
