
# Found this incompatibility when using dm-core (gem) with heroku (gem),
# and heroku is depending on activesupport (it should really just pick
# a json gem, instead of using activesupport), and then our app stopped
# working... Here's the minimal program to reproduce the problem.

# Sorry I don't have time to dig into this, hope this minimal program
# is enough to find out the problem. Thanks a lot!!

gem 'dm-core', '1.1.0'

require 'dm-core'
require 'dm-migrations'

class Cat
  include DataMapper::Resource
  property :id, Serial
  ###################################
  require 'dm-timestamps'    # needed
  timestamps :at             # needed
  property :created_at, Time # needed
  ###################################
end

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate!

p Cat.new.save # true
gem 'activesupport', '3.0.5'
require 'active_support/json'
p Cat.new.save # false
