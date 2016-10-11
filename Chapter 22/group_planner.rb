require 'runt'
include Runt

require 'linguistics'
Linguistics::use( :en )

require 'date'

(puts "#{$0} - plans monthly gatherings\nusage: #{$0} day_number day_name year\n"; 
         exit ) if ARGV.length != 3

day_number= ARGV.shift.dup.gsub(/(st|nd|rd|th)$/,'').to_i

day_names= Date::DAYNAMES.collect { |day| day.downcase }
day_name_argument = ARGV.shift.dup
day_name_value= day_names.index(day_name_argument.downcase) 

year = ARGV.shift.dup.to_i

header= "All of the #{day_number.en.ordinal} " <<
        "#{day_name_argument.en.plural} of #{year}"

puts header
puts "=" * (header.length)

date_expression = DIMonth.new(day_number, day_name_value)

date_expression.dates( DateRange.new(PDate.day(year,1,1),
                       PDate.day(year,12,31)) ).each do |date|
    puts date.strftime('%m-%d-%y')
end

