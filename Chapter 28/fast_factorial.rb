require 'memoize'
require 'benchmark'

(puts "usage: #{$0} number_of_times_to_calculate_factorial factorial_to_calculate " ; 
        exit) unless ARGV.length==2

runs = ARGV.shift.to_i
factorial_number = ARGV.shift.to_i

include Memoize  # This brings the Memoize module into the
                 # current object namespace.

def factorial(n)
    return 1 if n==0
    return factorial(n-1) * n
end

Benchmark.bm(11) do |bm|
    bm.report("without memoize") { runs.times { factorial(factorial_number) } }
    
    memoize :factorial
    bm.report("with memoize   ") { runs.times { factorial(factorial_number) } }
end

