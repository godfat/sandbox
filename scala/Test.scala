
abstract class Tree
  case class Node(l: Tree, r:Tree) extends Tree
  case class Leaf(v: Any) extends Tree

object Test{
  def main(args: Array[String]) =
    Console println "hello world!"
}
