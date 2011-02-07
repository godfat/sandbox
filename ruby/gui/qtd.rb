require 'Qt4'
include Qt
app = Application.new ARGV
hello = PushButton.new "Hello World!"
hello.resize 100, 30
hello.show
app.exec
