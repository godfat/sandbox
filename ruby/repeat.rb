
class Seq
  def initialize text
    @suffix_list = []
    len = text.length 
    len.times { |i| suffix_list << text[i, len] }  # the ,len] is a hack
    @suffix_list.sort!
    @suffix_list.inject{ |r, l|
    }
  end
end

puts Seq.new('banana')
puts
puts Seq.new('ababab')
