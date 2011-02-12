
class Parser
  Expression = %r{
    (?<number>    \d+(\.\d+)?                           ){0}
    (?<op0>       \*         | \/                       ){0}
    (?<op1>       \+         | \-                       ){0}
    (?<factor>    \g<number> | \(\g<expression>\)       ){0}
    (?<term>      \g<factor>   (\g<op0>\g<term>)?       ){0}
    (?<expression>\g<term>     (\g<op1>\g<expression>)? ){0}

    ^\g<expression>$
  }x
end
