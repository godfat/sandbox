$KCODE = 'u'
require 'rubygems'
require 'scruffy'

graph = Scruffy::Graph.new
graph.title = "Comparative Agent Performance"
graph.value_formatter = Scruffy::Formatters::Percentage.new(:precision => 0)
graph.add :stacked do |stacked|
        stacked.add :bar, '中文', [30, 60, 49, 29, 100, 120]
        stacked.add :bar, 'Jill', [120, 240, 0, 100, 140, 20]
        stacked.add :bar, 'Hill', [10, 10, 90, 20, 40, 10]
end
graph.point_markers = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
File.open('gg.jpg', 'w'){ |f|
  f << graph.render(:width => 800, :as => 'JPG')
}
