
class Base{
  def test(): Base = {
    println("base")
    this
  }
}

class Derived extends Base{
  override def test(): Null = {
    println("derived")
    null
  }
}

class List[+A]
case object Nil extends List[Nothing]


println("XD") // asd
