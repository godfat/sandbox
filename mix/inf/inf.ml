
(*
http://existentialtype.wordpress.com/2011/04/24/the-real-point-of-laziness/
*)

type nat = Zero | Succ of nat

let rec inf : nat = Succ inf;;
