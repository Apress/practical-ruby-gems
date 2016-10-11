require 'uri'
require 'open-uri'
require 'hpricot'

(puts "usage: #{$0} search_term "; exit) unless ARGV.length>0

search_term = ARGV.join(' ')

url = "http://practicalrubygems.com/examplestore/search/#{URI.encode(search_term)}"

doc = Hpricot(open(url))

products=[]
doc.search("table#products").each do |item|
  (item/'tr td').each do |td|
    product=Hash.new

    (td/"a").each do |navigation|
      product[:title]= navigation.inner_html
      product[:link]=  navigation.attributes['href']
    end

    price= (td/"span.price")
    product[:price]= price.inner_html if price.any?

    products << product
  end
end

products.each do |product|
  puts "#{product[:title]}, #{product[:price]}\n#{product[:link]}\n\n"
end

