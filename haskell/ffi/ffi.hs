
-- ghc ffi.hs stdio.c

import Foreign.C

foreign import ccall safe printf :: CString -> IO ()

main = withCString "Hello, World!\n" printf
