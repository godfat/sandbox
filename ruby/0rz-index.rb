#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

# http://www.blogger.com/feeds/4013660499115623904/posts/default/8669382733745187064
index = Nokogiri::XML.parse(open('http://blogger.godfat.org/2007/03/index-by-date.html').read)
current = index.css('.post-body p')[0].children.find{ |n| n.to_s =~/^(\d+)\./ }
number, last = $1.to_i, current.next['href']

atom = Nokogiri::XML.parse(open('http://blogger.godfat.org/feeds/posts/default').read)
result = []
atom.css('entry').each{ |entry|
  href = entry.css('link').find{ |link|
                             link['rel']  == 'alternate' &&
                             link['type'] == 'text/html'
                           }['href'].sub(%r{.*//[^/]*}, '')

  break if href == last
  result << [Time.parse(entry.css('published').inner_text).strftime('%m-%d') + ' ' +
             entry.css('title').inner_text, href]
}

result.each.with_index{ |post, index|
  puts "#{number + result.size - index}. <a href=\"#{post.last}\">#{post.first}</a>"
}
