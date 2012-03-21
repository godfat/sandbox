
-- ghc -I/usr/local/include/ruby-1.9.1/x86_64-darwin10.8.0 -I/usr/local/include/ruby-1.9.1 -lruby ffi-ruby.hs ruby.c

import Foreign.C

foreign import ccall safe ruby_init   :: IO ()
foreign import ccall safe eval_to_int :: CString -> IO CInt

main = do
  ruby_init
  withCString "1 + 2 + 3" eval_to_int >>= putStrLn . show
