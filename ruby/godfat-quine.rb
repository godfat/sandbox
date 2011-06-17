# _="_=%p;puts _%%_";puts _%_

# "Lin Jen Shin (godfat)%p;puts((ObjectSpace.each_object.find{|s|s.to_s.size==140}%%ObjectSpace.each_object.find{|s|s.to_s.size==140})[21..-1])";puts((ObjectSpace.each_object.find{|s|s.to_s.size==140}%ObjectSpace.each_object.find{|s|s.to_s.size==140})[21..-1])

# GC.disable # for rubinius

# "Lin Jen Shin (godfat) is a programmer who works for Cardinal Blue Software, loving computer games, Haskell, open source, and self-referential jokes, such as: %p;puts((ObjectSpace.each_object.find{|s|s.to_s.size==278}%%ObjectSpace.each_object.find{|s|s.to_s.size==278})[158..-1])";puts((ObjectSpace.each_object.find{|s|s.is_a?(String)&&s.size==278}%ObjectSpace.each_object.find{|s|s.is_a?(String)&&s.size==278})[158..-1])

# "Lin Jen Shin (godfat) is a programmer who works for Cardinal Blue Software, loving computer games, Haskell, open source, and self-referential jokes, such as: %p=~/(.+)/;puts(($1%%$1)[158..-1])"=~/(.+)/;puts(($1%$1)[158..-1])

"Lin Jen Shin (godfat) is a programmer who works for Cardinal Blue Software, loving computer games, open source, Haskell and self-referential jokes, such as: %p=~/(.+)/;puts(($1%%$1).sub(/^[^\"]+/,''))"=~/(.+)/;puts(($1%$1).sub(/^[^"]+/,''))
