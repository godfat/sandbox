
class T{
  def a = Console println "a"
}

trait Before extends T{
  override def a = {
    println("before a")
    super.a
    println("after a")
  }
}

val t: T = (new T with Before)
t.a
