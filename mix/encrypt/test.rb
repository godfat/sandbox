
require 'rubygems'
require 'crypt/blowfish'

blowfish = Crypt::Blowfish.new("A key up to 56 bytes long")
puts blowfish.decrypt_string('GXWdMi7gRbjZEDDBLnIl0ihH/iwhlJND'.unpack('m')[0], false)
puts [blowfish.encrypt_string('hello from ruby!!')].pack('m')
