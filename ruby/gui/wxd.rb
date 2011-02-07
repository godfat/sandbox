require 'rubygems'
require 'wx'
include Wx
class Hello < App
  def on_init
    hello = Frame.new nil, -1, "Hello"
    StaticText.new hello, -1, "Hello World!"
    hello.show
  end
end
Hello.new.main_loop
