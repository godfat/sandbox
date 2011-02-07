
implicit def envToTreeMap(env: Env) = env.map

abstract class Val
case class  Num(n: Int)        extends Val
case class  Cls(f: Val => Val) extends Val
case object Err                extends Val

abstract class Expr
case class Lit( n: Int)             extends Expr
case class Var( n: String)          extends Expr
case class Lam( n: String, e: Expr) extends Expr
case class App(e0: Expr,  e1: Expr) extends Expr
case class Add(e0: Expr,  e1: Expr) extends Expr

import scala.collection.immutable.TreeMap
class Env(val map: TreeMap[String, Val]){
  def this() = this(new TreeMap[String, Val])
  def insert(k: String, v: Val): Env = new Env(map.insert(k, v))

  def eval(expr: Expr): Val = expr match{
    case Lit(n)      => Num(n)

    case Var(n)      => map.get(n) match{
                          case Some(v) => v
                          case None    => Err
                        }

    case Lam( n,  e) => Cls((arg: Val) => {
                          insert(n, arg).eval(e)
                        })

    case App(e0, e1) => eval(e0) match{
                          case Cls(f) => f(eval(e1))
                          case _      => Err
                        }

    case Add(e0, e1) => (eval(e0), eval(e1)) match{
                          case (Num(e0), Num(e1)) => Num(e0 + e1)
                          case _                  => Err
                        }
  }
}

val expr: Expr = App(Lam("x", Add(Var("x"), Var("y"))), Lit(2))
val env:  Env  = (new Env).insert("y", Num(5))
println(env.eval(expr))
// Num(7)


// De Bruijn index

implicit def env2ToList(env: Env2) = env.list

abstract class Expr2
case class Lit2( n: Int)               extends Expr2
case class Var2( n: Int)               extends Expr2
case class Lam2( e: Expr2)             extends Expr2
case class App2(e0: Expr2,  e1: Expr2) extends Expr2
case class Add2(e0: Expr2,  e1: Expr2) extends Expr2

class Env2(val list: List[Val]){
  def this() = this(List())
  def ::(v: Val) = new Env2(v :: list)

  def eval(expr: Expr2): Val = expr match{
    case Lit2(n)      => Num(n)
    case Var2(n)      => list(n - 1)

    case Lam2(e)      => Cls((arg: Val) => {
                           (arg :: this).eval(e)
                         })

    case App2(e0, e1) => eval(e0) match{
                           case Cls(f) => f(eval(e1))
                           case _      => Err
                         }

    case Add2(e0, e1) => (eval(e0), eval(e1)) match{
                           case (Num(e0), Num(e1)) => Num(e0 + e1)
                           case _                  => Err
                         }
  }
}

val expr2: Expr2 = App2(Lam2(Add2(Var2(1), Var2(2))), Lit2(2))
val env2:  Env2  = Num(5) :: new Env2
println(env2.eval(expr2))
// Num(7)
