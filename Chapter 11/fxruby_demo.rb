require 'fox16'
require 'active_record'
require 'optparse'

$options = {}

opt=OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"
  opts.on("-H", "--host HOST", "host") { |h|  $options[:hostname] = h }
  opts.on("-u", "--username USERNAME", "username") { |u| $options[:username] = u }
  opts.on("-p", "--password PASSWORD", "password") { |p| $options[:password] = p }
  opts.on("-o", "--port PORT", "port") { |p|   $options[:port] = p }
  opts.on("-d", "--database DATABASE", "DATABASE") { |d| $options[:database] = d }
  opts.on("-t", "--table TABLE", "TABLE") { |t| $options[:table] = t }
  opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!

(puts "Please specify a table name.\n" << opt.help; exit) unless $options[:table]
(puts "Please specify a database.\n" << opt.help; exit) unless $options[:database]

$options[:hostname] ||= 'localhost'
$options[:username] ||= 'root'
$options[:password] ||= ''
$options[:port] ||= 3306

#First, we connect to the database that the user specified...
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => $options[:hostname],
  :username => $options[:username],
  :password => $options[:password],
  :database => $options[:database])

# and then we create an ActiveRecord model to represent it...

class OutputTable <  ActiveRecord::Base
  set_table_name $options[:table]
end

include Fox

fox_application=FXApp.new

# we're going to create a single window for our application; 
# it will be titled according to the name of our table.

main_window=FXMainWindow.new(fox_application, "Insert record into " << 
  #{Inflector.humanize($options[:table])}", nil, nil, DECOR_ALL )

# This matrix is like a table for our controls;
# it's a MATRIX_BY_COLUMNS matrix with two columns,
# which means that our app will have two columns of
# controls, which will line up nicely. The first
# column will be our labels, and the second column
# will be our text boxes.

control_matrix=FXMatrix.new(main_window,2, MATRIX_BY_COLUMNS)

# This array will contain all of our data entry controls - 
# we'll need this to insert the data into our model.

field_controls = []

OutputTable.columns.each do |col|
  FXLabel.new(control_matrix, Inflector.humanize(col.name))
  field_controls << [col.name,FXTextField.new(control_matrix, 30)]
end

# This is a blank frame; it does nothing but take up a space in
# the matrix.
# if this wasn't here, our "Insert button" would line up with
# our labels, but it looks nicer lined up with the text boxes.

FXHorizontalFrame.new(control_matrix, LAYOUT_FILL_X )

# This creates our "Insert button", and attaches some code
# to the SEL_COMMAND event; this event controls what happens
# when we click on it.

FXButton.new(control_matrix, 'Insert').connect(SEL_COMMAND) do
  OutputTable.new do |rec|
    field_controls.each do |field_control|
      name, control = *field_control
      rec.send("#{name}=", control.text)
    end
    rec.save
  end

  FXMessageBox.new(main_window, "Data Inserted",
  "Data inserted into table '#{Inflector.humanize($options[:table])}'.\n\nThanks!",
  nil, MBOX_OK | DECOR_TITLE).execute

end

fox_application.create

main_window.show( PLACEMENT_SCREEN )

fox_application.run

