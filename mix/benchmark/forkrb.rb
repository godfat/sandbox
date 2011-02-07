
require 'benchmark'
require 'thread'
require 'rubygems'
require 'facets'
require 'forkoff'

module Enumerable
  def fork2(max_number_of_threads=nil, &block)
    thread_limiter = EV::ThreadLimiter.new(max_number_of_threads)
    collect do |x|
      thread_limiter.fork do
        Thread.current.abort_on_exception = true

        r, w = IO.pipe

        if pid = Process.fork
          w.close
          Process.wait(pid)
          data  = r.read
          r.close
          Marshal.load(data)
        else
          r.close
          Marshal.dump(block.call(x), w)
          w.close
          exit
        end
      end
    end.collect do |t|
      t.value
    end
  end
end
module EV
  class ThreadLimiter
    def initialize(max_number_of_threads)
      @number_of_threads = 0
      @max_number_of_threads = max_number_of_threads

      yield(self) if block_given?
    end

    def fork(*args, &block)
      Thread.pass while @max_number_of_threads and
                        @max_number_of_threads > 0 and
                            @number_of_threads > @max_number_of_threads

      # If this methods is called from several threads, then
      # @number_of_threads might get bigger than @max_number_of_threads.
      # This usually a) isn't the case and b) doesn't really matter (to me...).
      # I'm willing to accept this "risk", because a) Thread.exclusive is
      # much, much faster than Mutex#synchronize and b) we can't run into
      # deadlocks.

      Thread.exclusive{@number_of_threads += 1}

      Thread.fork do
        begin
          res = block.call(*args)
        ensure
          Thread.exclusive{@number_of_threads -= 1}
        end

        res
      end
    end
  end
end

Benchmark.bm{ |bm|
  slow = lambda{ |i| (0..200_000).to_a.inject(&:+) }
  bm.report('raw'){     (0..5).to_a.each(&slow) }
  bm.report('fork2'){   (0..5).to_a.fork2(2, &slow) }
  bm.report('forkoff'){ (0..5).to_a.forkoff(&slow) }
}
