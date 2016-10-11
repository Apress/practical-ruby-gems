require 'tempfile'  # Ruby builtin library - no need to install.
require 'bluecloth'

html2ps_command='/path/to/html2ps'
#on win32, you'll need to prefix this with 'perl '
#   - win32 won't know to run the perl interpreter on it.

ps2pdf_command='/path/to/ghostscript/lib/ps2pdf'
#ps2pdf comes with ghostscript - it'll be in your ghostscript/lib directory .

if ARGV[0]=='-'
  input_string = $stdin.read
else
  input_string = File.read(ARGV[0])
end
output_pdf_filename =ARGV[1]

# Convert our BlueCloth input into HTML output

bc = BlueCloth::new( input_string )
html_string = bc.to_html

tmp_html_filename ="#{Dir::tmpdir}/#{$$}.html"
tmp_ps_filename = "#{Dir::tmpdir}/#{$$}.ps"

# Next, we take our BlueCloth input and turn it
# into a full HTML document, not just a fragment.

File.open(tmp_html_filename, 'w') do |f|
  f << "<html><head><title>bluecloth2pdf</title></head>"
  f << "<body>"
  f << html_string
  f << "</body>"
  f << "</html>"
end

# First, we convert the HTML and convert it into postscript using
# html2ps, and then convert it into a PDF document using ps2pdf.

`#{html2ps_command} < "#{tmp_html_filename}" > "#{tmp_ps_filename}"`
`#{ps2pdf_command} "#{tmp_ps_filename}" "#{output_pdf_filename}"`

