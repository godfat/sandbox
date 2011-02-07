val int_list: Array[Integer] = Array(1,2,3)
val any_list: RandomAccessSeq[Any] = int_list.readOnly

println(any_list(0))

import scala.collection.jcl.ArrayList

val jint_list: ArrayList[Integer] =
    new ArrayList[Integer](new java.util.ArrayList[Integer])
jint_list.add(123)
val jany_list: RandomAccessSeq[Any] = jint_list.readOnly

println(jany_list(0))

class Value[T](init: T){
  private var x: T = init
  def get: T = x
  def set(t: T) = x = t
}

def showValue[A](obj: A){
  obj.set(obj.get)
  println(obj.get)
}

showValue(new Value[Number](456))
showValue(new Value[String]("abc"))
