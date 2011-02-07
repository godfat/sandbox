
import Control.Monad.Reader

test :: Reader String Int
test = Reader read >>= \i -> return (i + 10) >>= \i -> return (i * 2)

test' :: Reader String Int
test' = do
          i  <- Reader read
          ii <- return (i + 10)
          return (ii * 2)

test'' :: Reader String Int
test'' = do
           i <- local (++ "0") (Reader read)
           return (i * 2)

-----------------------------------------------------------------------------

data Tem = Txt String | Var Tem deriving Show
type Env = [(String, String)]

env :: Env
env = [("asd", "150"), ("150", "zzz")]

lookupVar :: String -> Env -> Maybe String
lookupVar = lookup

resolve :: Tem -> Reader Env String
resolve (Txt str) = return str
-- resolve (Var tem) = do
--                        name <- resolve tem
--                        val  <- asks (lookupVar name)
--                        return (maybe "" id val)
-- 
-- resolve (Var tem) = resolve tem >>= \name -> asks (lookupVar name)
--                                 >>= \val  -> return (maybe "" id val)

resolve (Var tem) = resolve tem >>= \name -> ask >>= \env -> return (lookupVar name env)
                                >>= \val  -> return (maybe "" id val)

t1, t2, t3 :: String
t1 = runReader (resolve (Txt "qwe")) env             -- qwe
t2 = runReader (resolve (Var (Txt "asd"))) env       -- 150
t3 = runReader (resolve (Var (Var (Txt "asd")))) env -- zzz
