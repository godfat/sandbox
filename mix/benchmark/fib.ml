
let rec fib = fun n -> 
  if n<2
  then n
  else fib (n-1) + fib (n-2)
  ;;

for i = 0 to 34 do
  Printf.printf "n=%d => %d\n" i (fib i)
done
;;
