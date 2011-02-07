
class Human{
  def touch(m: Mutant): Human = {
    println("Human")
    this
  }
}

class Mutant extends Human{
  override def touch(h: Human): Mutant = {
    println("Mutant")
    this
  }
}

val h: Human = new Mutant
h.touch(new Mutant)

// class Human;
// class Mutant extends Human;
//
// val mutate = new Function1[Human, Mutant]{
//   def apply(h: Human) = new Mutant;
// }
//
// val false_heal: Function1[Mutant, Human] = mutate
// val me: Human = false_heal(new Mutant)
//
// val create: Function1[Null, Any] = mutate
// val any: Any = create(null)
//
// println(me)
//
// class Variable[T](data: T){
//   var data_ = data
//   def get(): T = data_
//   def set(data: T) = data_ = data
// }
//
// def assign[U >: String](v: Variable[U], s: String) = v.set(s)
//
// assign(new Variable[Any], "asd")
//
// class Value[+T](init:T) {
//     private val x:T = init
//     def get:T = { x }
//     def set[U >: T](x: U): Value[U] = new Value[U](x)
// }
//
// def showValue2(obj:Value[Any]) {
//    println(obj.get);
// }
//
// var str_value:Value[String] = new Value[String]("Hello, World!");
// var int_value:Value[Integer] = new Value[Integer](87);
//
// showValue2(str_value);
// showValue2(int_value);
