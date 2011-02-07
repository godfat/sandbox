
def honai n, src, buff, dest
  return if n == 0
  honai(n - 1, src, dest, buff)
  puts("move #{n} from #{src} to #{dest}")
  honai(n - 1, buff, src, dest)
end

def powerset set
  return [[]] if set.empty?
  sub = powerset(set[1..-1])
  sub + sub.map{ |a| [set.first] + a }
end

def powerset2 src, buff = [], n = 0
  if src.size == n
    p(buff)
  else
    powerset2(src, buff.dup << src[n], n + 1)
    powerset2(src, buff, n + 1)
  end
end

data = 'ABC'.scan(/./)

# honai(3, *data)
# p(powerset(data))
powerset2(data)
