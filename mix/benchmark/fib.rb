def fib n
  if n<2
    n
  else
    fib(n-1) + fib(n-2)
  end
end

35.times{ |i|
  puts "n=#{i} => #{fib(i)}"
}
