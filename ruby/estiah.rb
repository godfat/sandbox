
require 'nokogiri'

def wiki html
  html.css('.skill').select{|s| s.css('.c2 strong')}.map{ |s|
    title = s.css('.c2 strong').text
    link  = '<a href="http://progenitor-softworks.com/ew/index.php?title='
    sprintf('%-20s %-15s %s',
      title,
      s.css('.percent').text.strip,
      s.css('.rank').text.strip).
    gsub((title == '' ? /\A\Z/ : title),
         "#{link}#{title.gsub(' ','_')}\">#{title}</a>") }
end

def text html
  html.css('.skill').select{|s| s.css('.c2 strong')}.
       map{|s| sprintf('%-20s %-15s %s',
                 s.css('.c2 strong').text,
                 s.css('.percent').text.strip,
                 s.css('.rank').text.strip) }
end

html = Nokogiri::HTML.parse($stdin.read)

puts(case ARGV.first
      when 'wiki'; wiki(html)
      else;        text(html)
     end)
