
require 'Qt4'

class Game < Qt::Object
  slots 'menu(QAction*)'
  def menu action
    Qt::MessageBox::about Qt::Application.instance.activeModalWidget,
      'menu?', action.iconText
  end
end

app = Qt::Application.new ARGV
game = Game.new
win = Qt::MainWindow.new

menu = Qt::Menu.new 'say'
menu.addAction 'XD'
win.menuBar.addMenu menu
win.connect menu, SIGNAL('triggered(QAction*)'), game, SLOT('menu(QAction*)')

win.show
app.exec
