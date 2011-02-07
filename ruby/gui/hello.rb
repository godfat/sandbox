
require 'Qt4'

class AboutButton < Qt::PushButton
  slots :about
  def about
    Qt::MessageBox::about self, 'About', 'Hi, there!'
  end
end

app = Qt::Application.new ARGV
btn = AboutButton.new 'Hello, World!'
btn.connect btn, SIGNAL(:clicked), btn, SLOT('about()')
btn.show
app.exec
