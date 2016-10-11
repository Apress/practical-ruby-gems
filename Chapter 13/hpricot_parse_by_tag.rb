require 'hpricot'

document= <<END
<p>This is the first test paragraph.</p>
<ul>
  <li>This is the first list item.</li>
  <li>This is the second list item.</li>
</ul>
END

parser=Hpricot.parse(document)

(parser/:li).each do |list_item|
  puts list_item.inner_html
end

