
prime = Array.new( 6000000, true )
prime[0, 1] = false, false
length = prime.length
for i in 2..( prime.length ** 0.5 ).floor
  if prime[i]
    j = i << 1
    while j < length
      if prime[j]
        prime[j] = false
      end
      j += i
    end
  end
end
