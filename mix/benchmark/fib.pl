use strict;
sub fib{
  if($_[0] < 2){
    return $_[0];
  }
  else{
    return fib($_[0] - 1) + fib($_[0] - 2);
  }
}

for(my $i=0; $i<35; ++$i){
  print "n=$i => ".fib($i)."\n"
}
