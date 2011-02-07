
arg = ARGV.first

p ['help', 'he'].select{ |i| i[0...arg.length] == arg }
