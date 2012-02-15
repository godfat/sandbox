
Cat := Object clone
Cat name := ""
Cat meow := method("#{name}: meow~" interpolate println)

Alice := Cat clone
Alice name := "Alice"
Alice meow

Bob   := Cat clone
Bob   name := "Bob"
Bob   meow

Carol := Bob clone
Carol name := "Carol"
Carol meow

Bob jump := method("#{name}: jump~" interpolate println)
Bob jump

Carol jump

// Alice jump // no jump
