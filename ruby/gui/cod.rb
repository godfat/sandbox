require 'osx/cocoa'
include OSX

app = NSApplication.sharedApplication

hello = NSWindow.alloc.
  initWithContentRect_styleMask_backing_defer [200.0, 300.0, 100.0, 100.0],
  15, 2, 0
hello.setTitle 'Hello'

btn = NSButton.alloc.initWithFrame [10.0, 10.0, 80.0, 80.0]
hello.contentView.addSubview btn
btn.setTitle 'Hello World!'
btn.setAction 'stop:'
btn.setBezelStyle 4

hello.display
hello.orderFrontRegardless

app.run
