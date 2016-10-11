require 'runt'
include Runt

(puts "#{$0} - runs commands on the indicated Nth weekday of the month\n" << 
     "usage: #{$0} day_number day_name command\n"; 
    exit ) if ARGV.length <= 3

day_number= ARGV.shift.dup.gsub(/(st|nd|rd|th)$/,'').to_i

daynames= Date::DAYNAMES.collect { |day| day.downcase }

day_name_argument = ARGV.shift.dup
day_name_value= daynames.index(day_name_argument.downcase) 

date_expression = DIMonth.new(day_number, day_name_value)

if(date_expression.include?(Date.today))
  puts `#{ARGV.join(' ')}`
end

