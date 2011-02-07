
require 'rubygems'
require 'builder'

class Fixnum
  def xchr
    n = XChar::CP1252[self] || self
    case n when *XChar::VALID
      XChar::PREDEFINED[n] or (n<128 ? n.chr : [n].pack('U'))
    else
      '*'
    end
  end
end

builder = Builder::XmlMarkup.new
xml = builder.person { |b| b.name("大家來寫 ruby XD"); b.phone("555-1234") }
puts xml
