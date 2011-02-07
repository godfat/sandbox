
require 'rubygems'
require 'facets'
require 'kernel/demo'

class Proc
  def curry *pre
    lambda{ |*post| self[*(pre + post)] }
  end
  def chain *procs, &block
    procs << block if block
    lambda{ |*args|
      result = []
      ([self] + procs).each{ |i|
        result += [i[*args]].flatten
      }
      result
    }
  end
  def compose *procs, &block
    procs << block if block
    lambda{ |*args|
      ([self] + procs).reverse.inject(args){ |val, fun|
        fun[*val]
      }
    }
  end
end

multiply = lambda{|l,r| l*r}
double = multiply.curry 2
xd = multiply.curry 'XD', 5
demo{'double[2]'}
demo{'double[3]'}
demo{'xd.call'}

a1 = lambda{|a| a+1}
a2 = lambda{|a| a+2}
a3 = a1.chain a2
a4 = a3.chain a1
a5 = a4.chain{|a|[10,11]}
demo{'a3[5]'}
demo{'a4[1]'}
demo{'a5[0]'}

b1 = lambda{|b| b+1}
b2 = lambda{|b| b*2}
b3 = b1.compose b2
demo{'b3[10]'}

b4 = lambda{|a,b| a*b}
b5 = lambda{|a,b| [a*b, a-b]}
b6 = b4.compose b5
demo{'b6[3,5]'}
b7 = lambda{|a| a*2}.compose b6.compose{|a,b| [b,a]}
demo{'b7[3,5]'}
