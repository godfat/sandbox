
=begin
  3
 345
34567
 345
  3
=end

class Star
  attr_reader :max, :mid, :result
  def initialize max
    @max = max
    @mid = max / 2 + 1
    @result = (0...max).map{ |i| ([' '] * (mid-i-1).abs) + row(i) }
  end

  def row n
    (mid...max + mid - 2 * (mid - n - 1).abs).to_a
  end

  def to_s
    result.inject(''){ |s, l| "\n" + l.join + s }[1..-1]
  end
end

puts Star.new((ARGV.first || 5).to_i)
