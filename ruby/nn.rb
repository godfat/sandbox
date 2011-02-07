require 'rubygems'
require 'nitro'
class MyController
  def index; "Hello from nitro!"; end
end
Nitro.start MyController
