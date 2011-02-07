
require 'benchmark'

class C
  def im; end
  def self.cm; end
end

Benchmark.bm{ |bm|
  c = C.new
  bm.report('instance method call'){ 1000000.times{ c.im } }
  bm.report('class method call'){ 1000000.times{ C.cm } }
}
