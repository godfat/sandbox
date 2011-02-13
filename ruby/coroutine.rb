
FactFiber = lambda{
  Fiber.new{
          Fiber.yield(r  = x  = 1)
    loop{ Fiber.yield(r *= x += 1) }
  }
}

FactEnume = lambda{
  Enumerator.new{ |fiber|
          fiber <<    r  = x  = 1
    loop{ fiber <<    r *= x += 1  }
  }
}

require 'bacon'
Bacon.summary_on_exit

describe 'Coroutine' do
  before do
    @fiber = FactFiber.call
    @enume = FactEnume.call
  end

  should 'be correct' do
    result = [1, 2, 6, 24, 120]

    5.times.inject([]){ |r, _| r << @fiber.resume }.should == result
    5.times.inject([]){ |r, _| r << @enume.next   }.should == result

    @enume.rewind.take(5).should == result
  end

  should 'be the same with either Fiber or Enumerator' do
    10.times{ @fiber.resume.should == @enume.next }
  end
end
