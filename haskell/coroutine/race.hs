
-- cabal install monad-coroutine

import Data.IORef (IORef, newIORef, readIORef, writeIORef)
import Control.Monad.Trans (lift)
import Control.Monad.Coroutine (Coroutine, resume)
import Control.Monad.Coroutine.SuspensionFunctors (Yield(Yield), yield)

type Fiber = Coroutine (Yield ()) IO ()

fiber :: IORef Int -> Fiber
fiber i = do
            t <- lift (readIORef i)
            yield ()
            lift (writeIORef i (t + 1))
            return ()

main = do
  i <- newIORef 0
  let a = fiber i
      b = fiber i in do
      readIORef i >>= print -- 0
      Left (Yield _ a') <- resume a
      Left (Yield _ b') <- resume b
      resume a'
      resume b'
      readIORef i >>= print -- should be 2
