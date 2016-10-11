require 'markaby'
require 'yahoofinance'

(puts 'Usage: ruby stockgraph_markaby.rb ' << 
      'STOCK_SYMBOL STOCK_SYMBOL...'; exit) unless ARGV.length>0

graph=Hash.new

max=nil
min=nil

ARGV.each do |symbol|
 graph[symbol]=[]
 quotes=YahooFinance::get_HistoricalQuotes_days( symbol, 30 ) do |s|
   open_price=s.open
   date=s.date
   graph[symbol] << [date , open_price]
   max=open_price if max.nil? or (open_price > max)
   min=open_price if min.nil? or (open_price < min)
 end
end

builder=Markaby::Builder.new

builder.html do
  head do
    title "Stock Charts for #{ARGV.join(', ')}"
  end
  body do
    graph.each do |key, value|
      table :style=>"float:left; margin-right:2em;" do
        th "#{key.upcase}"
        value.each do |val|
          tr do
            td
          date, open = *val
          td "#{date} (#{open}) \t"
            td do
              div  :style=>"width:  #{((open.to_f - min)/(max - min) * 100) }px; " << 
                           "background-color:black;" do
                "&nbsp;"
              end
            end
          end
        end
      end
    end
  end
end

puts builder.to_s

