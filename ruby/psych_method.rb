
require 'psych'

puts Psych.dump(Struct.new(:method).new)
