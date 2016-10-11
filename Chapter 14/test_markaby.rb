require 'markaby'

mab=Markaby::Builder.new
mab.html do
  head do
    title 'Test Title'
  end
  body do
    h1 'Test Header'
    p 'Lorem ipsum dolor sit amet.'
  end
end

puts mab.to_s

