# encoding: utf-8

class Reader
  def initialize sock
    if sock.respond_to?(:read)
      self.sock   = sock
      self.buffer = ''
    else
      self.buffer = sock.to_str
    end
  end

  def peek
    buffer && buffer[0]
  end

  def getc
    buffer && if buffer.empty?
                raise EOFError.new if sock.nil? || sock.eof?
                self.buffer = sock.read(1024)
                getc
              else
                buffer.slice!(0)
              end
  end

  private
  attr_accessor :sock, :buffer
end

class Parser
  Expression = %r{
    (?<number>    \d+(\.\d+)?                           ){0}
    (?<op0>       \*         | \/                       ){0}
    (?<op1>       \+         | \-                       ){0}
    (?<factor>    \g<number> | \(\g<expression>\)       ){0}
    (?<term>      \g<factor>   (\g<op0>\g<term>)?       ){0}
    (?<expression>\g<term>     (\g<op1>\g<expression>)? ){0}

    ^\g<expression>$
  }x
end
