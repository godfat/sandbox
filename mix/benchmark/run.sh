

# real    0m0.597s
# user    0m0.344s
# sys     0m0.008s
# 
# real    0m0.363s
# user    0m0.341s
# sys     0m0.005s
# 
# real    0m0.346s
# user    0m0.340s
# sys     0m0.005s
# 
# real    0m0.345s
# user    0m0.339s
# sys     0m0.004s
# 
# real    0m0.370s
# user    0m0.332s
# sys     0m0.005s
# 
# real    0m0.311s
# user    0m0.301s
# sys     0m0.006s
# 
# real    0m1.294s
# user    0m0.362s
# sys     0m0.080s
# 
# real    0m4.993s
# user    0m0.544s
# sys     0m0.134s
# 
# real    0m0.486s
# user    0m0.406s
# sys     0m0.017s
# 
# real    0m2.144s
# user    0m2.081s
# sys     0m0.020s
# 
# real    0m8.642s
# user    0m8.468s
# sys     0m0.018s
# 
# real    0m25.642s
# user    0m25.481s
# sys     0m0.033s
# 
# real    0m6.187s
# user    0m6.168s
# sys     0m0.011s
# 
# real    0m30.681s
# user    0m29.794s
# sys     0m0.071s
# 
# real    0m15.055s
# user    0m14.823s
# sys     0m0.076s
# 
# real    0m14.892s
# user    0m14.185s
# sys     0m0.114s
# 
# real    0m36.07s
# user    0m35.88s
# sys     0m0.03s

# 1st
echo './fib-gdc024'
time ./fib-gdc024

# 2nd
echo './fib-como438'
time ./fib-como438
echo './fib-gcc4-apple'
time ./fib-gcc4-apple
echo './fib-gcc42-mp'
time ./fib-gcc42-mp
echo './fib-gcc43-mp'
time ./fib-gcc43-mp

#
echo './fib-ocaml'
time ./fib-ocaml

# 3rd
echo 'java Fib'
time java -server Fib

# 4th
echo './fib-gcj42-mp'
time ./fib-gcj42-mp

# 5th
echo './mono fib.exe'
time mono fib.exe

# 6th
echo './fib-ghc661'
time ./fib-ghc661

###############

echo 'clisp241'
time clisp fib-clisp241

echo 'ruby18'
time ruby fib.rb
echo 'ruby19'
time /opt/local/ruby-svn/bin/ruby-svn fib.rb

echo 'php524'
time php fib.php

echo 'python24'
time python2.4 fib.py
echo 'python25'
time python2.5 fib.py

echo 'perl58'
time perl fib.pl
