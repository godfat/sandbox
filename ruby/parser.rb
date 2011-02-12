# encoding: utf-8

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

    protected
    attr_accessor :sock, :buffer
  end

  class Lexer
    class Token
      attr_accessor :data
      protected :data=
      def initialize data; self.data = data; end
    end

    ParenthesisL = Token.new('(')
    ParenthesisR = Token.new(')')
    Multiply     = Token.new('*')
    Divide       = Token.new('/')
    Plus         = Token.new('+')
    Substract    = Token.new('-')

    def initialize sock; self.sock = sock; end

    def gett
      case c = reader.getc
        when   ''; gett
        when  '('; ParenthesisL
        when  ')'; ParenthesisR
        when  '*'; Multiply
        when  '/'; Divide
        when  '+'; Plus
        when  '-'; Substract
        when /\d/; Token.new(number(c))
      end
    end

    protected
    attr_accessor :sock
    def reader; @reader ||= Reader.new(sock); end

    def number c
      int = c + read_number
      if reader.peek == '.'
        reader.getc
        "#{int}.#{read_number}".to_f
      else
        int.to_i
      end
    end

    def read_number
      r = ''
      r << reader.getc while (c = reader.peek) =~ /\d/
      r
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'bacon'
  Bacon.summary_on_exit
  describe Parser::Lexer do
    should 'lex 1+2+3' do
      exp = '1+2+3'
      lex = Parser::Lexer.new(exp)
      exp.each_char{ |c|
        t = if c =~ /\d/ then c.to_i else c end
        lex.gett.data.should == t
      }
      lambda{ lex.gett }.should.raise(EOFError)
    end

    should 'lex 5.6' do
      Parser::Lexer.new('5.6').gett.data.should == 5.6
    end
  end
end
