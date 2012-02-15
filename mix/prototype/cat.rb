
Cat = Class.new
def Cat.name= name
  @name = name
end
def Cat.meow
  puts "#{@name}: meow~"
end

Alice = Class.new(Cat)
Alice.name = "Alice"
Alice.meow

Bob = Class.new(Cat)
Bob  .name = "Bob"
Bob  .meow

Carol = Class.new(Bob)
Carol.name = "Carol"
Carol.meow

def Bob.jump
  puts "#{@name}: jump~"
end
Bob.jump

Carol.jump

# Alice.jump # no jump
