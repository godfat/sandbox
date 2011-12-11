
require 'ffi'

module MyLib
  extend FFI::Library
  ffi_lib './libmylib.so'
  attach_function :plus, [:int ,:int], :int
end

p MyLib.plus(1, 2)
