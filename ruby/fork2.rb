
# require 'fcntl'

io = File.open('fork2.rb.txt', 'w')
puts 0
# io.fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC)
io.puts 'master'
io.flush
p(3.times{fork do
  io.puts 'worker'
  puts 1
  puts 3
  sleep 1
  puts 4
end})
puts 2
p Process.waitall
