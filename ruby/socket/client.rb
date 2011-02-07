    require 'socket'

    10.upto(100) {|i|
      text = "a" * i*(10**7)
      start = Time.now
      bob = TCPsocket.open('127.0.0.1', '9999')
      bob.write("#{text}\n")
      bob.close
      puts Time.now - start
    }
