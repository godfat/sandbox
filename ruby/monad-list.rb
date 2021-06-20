
module Monad
  Boolean = Object.new

  class List
    def bind arguments=nil, &block
      if arguments
        type_check(arguments)

        arguments.flat_map do |arg|
          instance_exec(arg, &block)
        end
      else
        instance_exec(&block)
      end
    end

    def unit value
      [value]
    end

    private

    def type_check arguments
      classes = normalize_boolean(arguments.map(&:class)).uniq
      classes.one? ||
        raise(ArgumentError.new("Types are not consistent: #{classes}"))
    end

    def normalize_boolean types
      types.map do |type|
        if type == TrueClass || type == FalseClass
          Boolean
        else
          type
        end
      end
    end
  end

  module_function
  def list
    List.new
  end
end

def powerset list
  return [[]] if list.empty?

  x, *xs = list

  Monad.list.bind do
    bind [true, false] do |yes|
      bind powerset(xs) do |ys|
        if yes
          unit [x, *ys]
        else
          unit ys
        end
      end
    end
  end
end

p powerset((0..4).to_a)
