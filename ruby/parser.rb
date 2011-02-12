# encoding: utf-8

class Parser
  RegularExpression = %r{
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

  class HandWritten
    def initialize sock; self.sock = sock; end
    def evaluate
      expression
    end

    protected
    attr_accessor :sock
    def lexer; @lexer ||= Lexer.new(sock); end
    def expression

    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'bacon'
  Bacon.summary_on_exit

  describe Parser do
    before do
      @exps = %w[1+2+3 5*2+6 (1+2)*4 1+2*4 5+6.1*3 1-4/8]
      @anws =   [6   , 16  , 12    , 9   , 23.9  , 0.5]
      @bads = %w[1.2a  1..6  (1+2*4  67+   5)      1-5//5]
    end

    describe 'Parser::RegularExpression' do
      should 'match or not match various things' do
        @exps.each{ |exp| exp.should =~ Parser::RegularExpression }
        @bads.each{ |exp| exp.should !~ Parser::RegularExpression }
      end
    end

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

    describe Parser::HandWritten do
      should 'parse 1+2+3=6' do
        Parser::HandWritten.new('1+2+3').evaluate.should == 6
      end
    end
  end
end
