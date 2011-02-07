
require 'benchmark'

class Array
  def rotate1(n=1)
    self.dup.rotate1!(n)
  end
  def rotate1!(n=1)
    n = n.to_int
    return self if (n == 0 or self.empty?)
    if n > 0
      n.abs.times{ self.unshift( self.pop ) }
    else
      n.abs.times{ self.push( self.shift ) }
    end
    self
  end
end

class Array
  def rotate2 n = 1
    return self if empty? or n == 0
    self[-n..-1] + self[0...-n]
  end
  # in-place version of rotate
  def rotate2!
    replace rotate2
  end
end

Benchmark.bm{ |bm|
  times = 500000
  a = (0..9).to_a
  bm.report{ times.times{ a.rotate1 } }
  bm.report{ times.times{ a.rotate1!} }
  bm.report{ times.times{ a.rotate2 } }
  bm.report{ times.times{ a.rotate2!} }
}
