
-- cabal install monad-coroutine

import Control.Concurrent.STM (atomically, retry, TVar, STM,
                               newTVar, readTVar, writeTVar)
import Control.Monad.Trans (lift)
import Control.Monad.Coroutine (Coroutine, resume)
import Control.Monad.Coroutine.SuspensionFunctors (Yield(Yield), yield)

fiber :: TVar Int -> Coroutine (Yield ()) STM ()
fiber i = do
            t <- lift (readTVar i)
            yield ()
            lift (writeTVar i (t + 1))
            return ()

main = do
  i <- atomically (newTVar 0)
  let a = fiber i
      b = fiber i in do
      atomically (readTVar i) >>= print -- 0
      Left (Yield _ a') <- atomically (resume a)
      Left (Yield _ b') <- atomically (resume b)
      atomically (resume a')
      atomically (resume b')
      atomically (readTVar i)  >>= print -- should be 2
