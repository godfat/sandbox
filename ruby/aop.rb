
require 'rubygems'
# require 'facets/more/cut'
# 
class Person
  attr_reader :name
  def initialize name
    @name = name
  end
  def say words
    puts "#{self.name} said: #{words}."
    self
  end
end
# 
# cut :Person_cut < Person do
#   def name
#     "<#{super}>"
#   end
# end
# 
# Person.new('godfat').say 'hi'
# puts; puts;

require 'aspectr'

class Hooker < AspectR::Aspect
  def pre method, object, status, *args
    puts "#{object}.#{method} is called with #{args.inspect}."
  end
  def post method, object, status, *args
    puts "#{object}.#{method} is exited with #{status.inspect}."
  end
end



Hooker.new.wrap Person, :pre, :post, /say/
sky = Person.new('sky').say 'hello'
puts; puts;



class Hacker < AspectR::Aspect
  def hack *args
    puts 'ccc'
  end
end

Hacker.new.wrap Person, :hack, :hack, /say/
sky.say 'XD'
