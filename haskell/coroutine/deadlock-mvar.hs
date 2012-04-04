
-- cabal install monad-coroutine

import Control.Concurrent.MVar (MVar, newMVar, readMVar, takeMVar, putMVar)
import Control.Monad.Trans (lift)
import Control.Monad.Coroutine (Coroutine, resume)
import Control.Monad.Coroutine.SuspensionFunctors (Yield(Yield), yield)

type Fiber = Coroutine (Yield ()) IO ()

fiber :: MVar Int -> Fiber
fiber i = do
            t <- lift (takeMVar i)
            yield ()
            lift (putMVar i (t + 1))
            return ()

main = do
  i <- newMVar 0
  let a = fiber i
      b = fiber i in do
      readMVar i >>= print -- 0
      Left (Yield _ a') <- resume a
      Left (Yield _ b') <- resume b -- deadlock
      return ()
