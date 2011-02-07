    require 'socket'

    server = TCPServer.new('127.0.0.1', '9999')
    while (alice = server.accept)
        start = Time.now
        tmp = alice.read
        puts Time.now - start
    end
