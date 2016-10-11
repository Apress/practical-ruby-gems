require 'hpricot'
document= <<END
<h1 class="big_header">This is a header.</h1>
<h1 class="big_header">This is the second big header.</h1>
<p>This is the first test paragraph.</p>
<ul>
<li>This is the first list item.</li>
<li>This is the second list item.</li>
</ul>
<p id="footer_paragraph">Lorem dolor sit amet...</p>
END

parser=Hpricot.parse(document)

puts (parser/'#footer_paragraph').inner_html

(parser/'h1.big_header').each do |list_item|
  puts list_item.inner_html
end

