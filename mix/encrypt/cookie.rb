
require 'rubygems'
require 'crypt/rijndael'
require 'crypt/blowfish'
require 'benchmark'

Benchmark.bmbm{ |bm|
  rijndael = Crypt::Rijndael.new("A key 16, 24, or 32 bytes length", 128, 128)
  blowfish = Crypt::Blowfish.new("A key up to 56 bytes long")
  plainBlock = "ABCDEFGH12345678"

  bm.report('rijndael'){
    30.times{
      encryptedBlock = rijndael.encrypt_string(plainBlock)
      decryptedBlock = rijndael.decrypt_string(encryptedBlock)
    }
  }
  bm.report('blowfish'){
    30.times{
      encryptedBlock = blowfish.encrypt_string(plainBlock)
      decryptedBlock = blowfish.decrypt_string(encryptedBlock)
    }
  }
}
