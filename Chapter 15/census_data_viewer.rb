require 'fastercsv'
require 'open-uri'

url='http://www.census.gov/popest/national/files/NST_EST2005_ALLDATA.csv'

data=open(url)

fastercsv.parse(data) do |row|
  area=row[4]
  population=row[5]
  puts "#{area} #{population}"
end

