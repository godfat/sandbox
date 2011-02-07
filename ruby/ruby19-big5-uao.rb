
# ENV['NOKOGIRI_FFI'] = '1'

require 'mechanize'

p Nokogiri::VERSION_INFO

node = Mechanize.new.get('http://www.ptt.cc/man/Japanese-B95/index.html').
       root.css('#finds > p')

puts .text.
     force_encoding('big5-uao').encode('utf-8', :invalid => :replace, :undef => :replace)

# output:
# <p>您現在的位置是 Japanese-B95 -          読み込み中
