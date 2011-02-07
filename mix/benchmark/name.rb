
require 'benchmark'

Benchmark.bm{ |bm|
  n = 50000
  puts 'NameError'
  bm.report{
    n.times{
      begin; var; rescue; end
    }
  }
  puts 'local_variables.include?'
  bm.report{
    n.times{
      local_variables.include? 'var'
    }
  }
  puts 'global_variables.include?'
  bm.report{
    n.times{
      global_variables.include? 'var'
    }
  }
  10.times{ |i| eval("$a#{i} = 1") }
  puts 'many variables in global_variables.include?'
  bm.report{
    n.times{
      global_variables.include? 'var'
    }
  }
  puts 'hash optimized many variables in global_variables'
  bm.report{
    vars = Hash[*global_variables.zip([true]*global_variables.size).flatten]
    n.times{
      vars['var']
    }
  }
}
