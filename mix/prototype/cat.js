// node cat.js
var Cat = {};
Cat.name = "";
Cat.meow = function(){ console.log(this.name + ": meow~"); };

var Alice = {__proto__: Cat};
Alice.name = "Alice";
Alice.meow();

var Bob = {__proto__: Cat};
Bob.name = "Bob";
Bob.meow();

var Carol = {__proto__: Bob};
Carol.name = "Carol";
Carol.meow();

Bob.jump = function(){ console.log(this.name + ": jump~"); };
Bob.jump();

Carol.jump();

// Alice.jump(); // no jump for Alice
