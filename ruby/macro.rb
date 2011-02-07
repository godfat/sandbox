
def oor exp
  if r = exp.first
    r
  else
    exp.last
  end
end

p (0..9).map{ |n| [n % 2 == 0, n] }.map(&method(:oor))
