
# written by caasi Huang

class Prototype
  attr_accessor :prototype
  def initialize *obj
    if(obj.length != 0)
      raise "not a prototype instance!" unless obj.first.respond_to? "prototype"
      @__proto__ = obj.first.prototype
    end
  end
  def method_missing msg, *args, &block
    @__proto__.send msg, *args, &block
  end
end

Cat = Prototype.new
def Cat.meow
  puts "meow~"
end

# set Alice's prototype to Cat
Alice = Prototype.new
Alice.prototype = Cat
# but Alice can't meow yet
#Alice.meow

a = Prototype.new Alice
a.meow

def Cat.jump
  puts "**jump**"
end

a.jump
