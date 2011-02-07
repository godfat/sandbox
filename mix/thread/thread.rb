a = 0
start = Time.new
t = Thread.new{
  while a < 5000000
    a += 1
  end
}.join

while a < 5000000
  # sleep 0
end
puts Time.new - start

puts a
