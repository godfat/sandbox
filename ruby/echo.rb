
require 'eventmachine'

module EchoServer
  def receive_data(data)
    # File.open('emailssssss.txt', 'a+'){ |log| log << data }
    print(data)
    send_data(data)
  end
end

EventMachine::run do
  host = '0.0.0.0'
  port = 8080
  EventMachine.start_server host, port, EchoServer
  puts "Started EchoServer on #{host}:#{port}..."
end
