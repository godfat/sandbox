
Array::head = -> this[0]
Array::tail = -> this[1..-1]

###
Array::foldr = (func, init) ->
  if this.length == 0
    init
  else
    this.tail().foldr(func, func(this.head(), init))
###

Array::foldr = Array.prototype.reduceRight

Array::max = ->
  this.tail().foldr(
    (i, r) -> if i > r
                i
              else
                r
    this.head())

Array::min = ->
  this.tail().foldr(
    (i, r) -> if i < r
                i
              else
                r
    this.head())

Array::zip = (rhs) ->
  if  this.length == 0
    rhs
  else if rhs.length == 0
    this
  else
    [[this.head(), rhs.head()]].concat(this.tail().zip(rhs.tail()))

list = [1..10]

console.log list.max()
console.log list.min()
console.log list.zip([10..1])
