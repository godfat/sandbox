#!/usr/bin/env ruby
# encoding: utf-8

# Ruby Quiz #158

%w[ Class <<self Symbol ].reverse.each{ |klass|
  eval <<-RUBY.split(/真常/).join
    class #{klass}
      # dirty 1.8 compatibility
      def public_send *args
        respond_to?(args.first) && send(*args)
      end unless respond_to?(:public_send)

      # full 1.8 compatibility
      def public_send *args
        if respond_to?(args.first)
          send(*args)
        else
          msg = " `\#{args.first}' called for \#{inspect}:\#{self.class}"
          if respond_to?(args.first, true)
            raise NoMethodError.new(  'private method' + msg)
          else
            raise NoMethodError.new('undefined method' + msg)
          end
        end
      end if RUBY_VERSION < '1.9.0'

      # rubinius, jruby compatibility
      def to_proc
        msg = self
        lambda{ |*args| args.shift.public_send(msg, *args) }
      end

      真常 define_method(:method_missing, &:say)
    end
  RUBY
}
Class.send(:define_method, :const_missing,
  &lambda{ |c| cry c.to_s[0..-2] })
def say s = nil
  print s, ' ' if s
  self
end
public :say
sing Hello.World!
puts
__END__
Apache License 2.0
