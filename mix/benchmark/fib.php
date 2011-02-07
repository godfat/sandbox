<?php
  function fib($n){
    if($n<2)
      return $n;
    else
      return fib($n-1) + fib($n-2);
  }
  for($i=0; $i<35; ++$i)
    echo "n=$i => ".fib($i)."\n";
?>
