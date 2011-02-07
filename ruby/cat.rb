
require 'aasm'

class Cat
  include AASM
  attr_writer :stomach

  # how would you like to read the state?
  # database? memcache?
  def aasm_read_state
    puts " read: Examining stomach... #{@stomach || 'nothing'}!"
    @stomach
  end

  # how would you like to write the state?
  # database? memcache?
  def aasm_write_state_without_persistence food
    puts "write: Eating... #{food}!"
    @stomach = food
  end

  # state exit callback and state enter callback
  aasm_state :nothing, :exit => :ate
  aasm_state :fish,   :enter => :found

  # guard if this transition could process
  aasm_event :eat do
    transitions :from => [:nothing],
                  :to => :fish,
               :guard => :fish_left?
  end

  # state transition callback
  aasm_event :digest do
    transitions :from => [:fish, :nothing],
                  :to => :nothing,
       :on_transition => :digesting
  end

  def ate
    puts " exit: Ate #{aasm_current_state}..."
  end

  # don't do this, state callback would be called
  # when reading from database/memcache to initialize
  # so this would yield unexpected result.
  # state callback should have no side-effect at all.
  # put side-effect only in transition callback
  def found
    puts "enter: Found #{@fish_amount} fish left!"
    @fish_amount -= 1
  end

  def fish_left?
    puts "guard: fish left: #{@fish_amount ||= 2}"
    @fish_amount > 0
  end

  def digesting
    puts "on_transition: Digesting #{aasm_current_state}..."
  end

  # pool man's state pattern, always cause a write on database/memcache
  # you can setup a cache (e.g. instance_variable) in
  # `aasm_read_state' and `aasm_write_state_without_persistence'
  # to skip writing if it's equal, e.g.
  # def aasm_read_state
  #   @state_cache = read
  # end
  # def aasm_write_state_without_persistence new_state
  #   write(new_state) if @state_cache != new_state
  # end
  #
  # and aasm event won't return the result from the method,
  # it always returns a true... so this is a bad way to do
  # state pattern :( need to extend it!
  def say_nothing
    puts '  say: I have nothing...'
  end

  def say_fish
    puts '  say: I have fish!'
  end

  states = aasm_states.map(&:name)
  aasm_event :say do
    states.each{ |state|
      transitions :from => [state],
                    :to =>  state,
         :on_transition => "say_#{state}".to_sym
    }
  end
end

def test c = Cat.new
  puts '-'*30
  puts 'c.digest'; c.digest; puts
  puts 'c.eat'   ; c.eat   ; puts
  puts 'c.digest'; c.digest; puts
  puts 'c.digest'; c.digest; puts
  puts 'c.eat'   ; c.eat   ; puts
  puts 'c.say'   ; c.say   ; puts
  c.send(:instance_variable_set, '@aasm_current_state', nil)
  c
end

test(test)

__END__
~> ruby -v
ruby 1.9.1p376 (2009-12-07 revision 26041) [i386-darwin10]

~> gem list aasm

*** LOCAL GEMS ***

aasm (2.1.5)

~> ruby cat.rb
------------------------------
c.digest
 read: Examining stomach... nothing!
write: Eating... nothing!
 exit: Ate nothing...
on_transition: Digesting nothing...
write: Eating... nothing!

c.eat
 exit: Ate nothing...
guard: fish left: 2
enter: Found 2 fish left!
write: Eating... fish!

c.digest
on_transition: Digesting fish...
write: Eating... nothing!

c.digest
 exit: Ate nothing...
on_transition: Digesting nothing...
write: Eating... nothing!

c.eat
 exit: Ate nothing...
guard: fish left: 1
enter: Found 1 fish left!
write: Eating... fish!

c.say
  say: I have fish!
enter: Found 0 fish left!
write: Eating... fish!

------------------------------
c.digest
 read: Examining stomach... fish!
on_transition: Digesting fish...
write: Eating... nothing!

c.eat
 exit: Ate nothing...
guard: fish left: -1

c.digest
 exit: Ate nothing...
on_transition: Digesting nothing...
write: Eating... nothing!

c.digest
 exit: Ate nothing...
on_transition: Digesting nothing...
write: Eating... nothing!

c.eat
 exit: Ate nothing...
guard: fish left: -1

c.say
 exit: Ate nothing...
  say: I have nothing...
write: Eating... nothing!
