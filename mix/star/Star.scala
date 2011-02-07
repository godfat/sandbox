
/*
  3
 345
34567
 345
  3
*/

class Star(max: Int){
  val mid = max / 2 + 1
  def row(n: Int): List[Int] =
    for (i <- List.range(mid, max + mid - 2 * (mid - n - 1).abs)) yield i

  val result =
    for (i <- List.range(0, max)) yield
      List.range(0, (mid - i - 1).abs).map{s=>' '} ++ row(i)

  override def toString: String =
    result.foldRight(""){
      (l, s) => "\n" + l.mkString + s
    }.drop(1).toString
}

println(new Star(5))
