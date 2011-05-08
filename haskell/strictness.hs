
-- undefined -> ()
test0 :: a -> ()
test0    _  = ()

-- undefined -> exception undefined
test1 :: () -> ()
test1    ()  = ()

-- undefined -> ()
-- Warning: Pattern match(es) are overlapped
test2 :: () -> ()
test2     _  = ()
test2    ()  = ()

-- undefined -> exception undefined
-- Warning: Pattern match(es) are overlapped
test3 :: () -> ()
test3    ()  = ()
test3     _  = ()

data DUnit = DUnit

-- undefined -> ()
test4 :: DUnit -> ()
test4        _  = ()

-- undefined -> exception undefined
test5 :: DUnit -> ()
test5    DUnit  = ()

-- undefined -> ()
test6 :: DUnit -> ()
test6   ~DUnit  = ()

-- always True
test7 :: Bool -> Bool
test7 ~True = True
test7 False = False

-- undefined -> exception undefined
-- True      -> True
-- False     -> exception irrefutable pattern failed
-- Warning: Pattern match(es) are overlapped
test8 :: Bool -> Bool
test8 ~true@True = true
test8 False = False

newtype NUnit = NUnit ()

-- undefined -> ()
test9 :: NUnit -> ()
test9 (NUnit _) = ()

-- undefined -> exception undefined
test10 :: NUnit -> ()
test10 (NUnit ()) = ()

newtype NUnit' = NUnit'{ getUnit :: () }

-- undefined -> ()
test11 :: NUnit' -> ()
test11 nu = let u = getUnit nu
            in ()
