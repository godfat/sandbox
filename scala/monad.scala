
// http://people.cs.kuleuven.be/~dave.clarke/FST/scala3.pdf

trait Monad[+a]{
  def >>=[b](f: a => Monad[b]): Monad[b]

  // ignore below, is there any method alias?
  def map[b](f: a => Monad[b]): Monad[b] = this >>= f
  def flatMap[b](f: a => Monad[b]): Monad[b] = this >>= f
}

abstract class Maybe[+a] extends Monad[a]{
  override
  def >>=[b](f: a => Monad[b]): Monad[b] = this match{
    case Just(a) => f(a)
    case      _  => Void
  }
}

case object Void extends Maybe[Nothing]
// resolve ambiguity of Int, Short, and Char
case object VoidI extends Maybe[Int]
case class Just[+a](aa: a) extends Maybe[a]

abstract class State[a, b] extends Monad[a, b]{
  
}

// use bind directly
println(Just(2) >>= ((x: Int) => Just(x * 2)))

// do notation, can't use return (unit). calls map underneath
println(for(a <- Just(2)) yield(Just(a * 2)))

// do notation, can't use return (unit). calls flatMap underneath
println(for(a <- Just(2); b <- Just(3)) yield(Just(a * b)))

// same as above, but need to use VoidI instead of Void due to ambiguity...
println(for(a <- Just(2); b <- VoidI) yield(Just(a * b)))
