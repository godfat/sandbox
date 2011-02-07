require 'rubygems'
require 'fox16'
include Fox
app = FXApp.new
hello = FXMainWindow.new app, "Hello"
FXButton.new hello, "Hello World!"
app.create
hello.show
app.run
