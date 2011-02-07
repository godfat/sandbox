
#   3
#  345
# 34567
#  345
#   3

from functools import reduce

class Star:
  def __init__(self, max):
    self.max = max
    self.mid = max // 2 + 1
    self.result = [ [' '] * abs(self.mid-i-1) +
      list(map(lambda x: str(x), list(self.row(i)))) for i in range(max) ]

  def row(self, n):
    return range(self.mid, self.max + self.mid - 2 * abs(self.mid - n - 1))

  def __str__(self):
    return reduce(lambda s,l: "\n"+''.join(l)+str(s), self.result, '')[1:]

print(Star(5))
