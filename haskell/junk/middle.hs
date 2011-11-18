{-# OPTIONS -XTypeSynonymInstances #-}

--
-- newtype App e a = App{ runApp :: e -> a }
-- newtype Middleware e a = Middleware{ runMiddleware :: App e a -> App e a }
--
-- plusone :: App Int Int
-- plusone = App (+1)
--
-- double :: Middleware Int Int
-- double = Middleware $ \app -> App $ (runApp app) . (*2)
--
-- dd :: Middleware Int Int
-- dd = Middleware $ (runMiddleware double) . (runMiddleware double)
--
-- instance Monad (Middleware e) where
--   return a = Middleware (const (App (const a)))
--   m >>=  f = Middleware $ \app -> App (\e -> runApp (runMiddleware (f e) app) e)

type App e a = e -> a
type Middle e a = App e a -> App e a

plusone :: App Int Int
plusone = (+1)

double :: Middle Int Int
double = (.(*2))

dd :: Middle Int Int
dd = double . double

-- instance Monad (Middle e) where
--   return a = id
--   -- m >>=  f =
