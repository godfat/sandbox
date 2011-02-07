$KCODE = 'u'
require 'jcode'
require 'rubygems'
require 'tidy'
Tidy.path = '/opt/local/lib/libtidy.dylib'
=begin
html = '<p>test設<i>'
xml = Tidy.open do |tidy|
  tidy.options.input_xml = true
  tidy.options.output_xml = true

  tidy.options.input_encoding = :utf8
  tidy.options.output_encoding = :utf8

  tidy.clean html
end
puts xml
=end

require 'open-uri'

msg = Tidy.open do |tidy|
  tidy.options.input_xml = true
  tidy.options.output_xml = true
  tidy.options.input_encoding = :utf8
  tidy.options.output_encoding = :utf8

  tidy.clean '<message>' + open('test.xml').read + '</message>'
end

require 'rexml/document'

msg = REXML::Document.new msg
words = []

def extract words, elements
  if elements.kind_of? REXML::Text
    words << elements.to_s
  elsif elements.kind_of? REXML::Element
    elements.each{ |e| extract words, e }
  else
    raise TypeError.new('what is it? : ' + elements.inspect)
  end
end

extract words, msg
puts a = words.join
puts a.jsize

# msg.each_recursive{ |element|
#   element.each_with_index{ |text, index|
#     words += text.to_s if text.kind_of? REXML::Text
#     puts index
#   }
# }

# require 'active_support'
# hash = Hash.from_xml msg
# p hash
