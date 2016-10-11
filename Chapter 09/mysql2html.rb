require 'erubis'
require 'active_record'
require 'optparse'

$options = {}

opt=OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] hostname.com file1 file2 file3..."

  opts.on("-H", "--host HOST", "host") { |h|    $options[:hostname] = h }
  opts.on("-u", "--username USERNAME", 
          "username") { |u|    $options[:username] = u }
  opts.on("-p", "--password PASSWORD", 
          "password") { |p|    $options[:password] = p }
  opts.on("-o", "--port PORT", "port") { |p|    $options[:port] = p }
  opts.on("-d", "--database DATABASE", "DATABASE") { |d|    
          $options[:database] = d }
  opts.on("-t", "--table TABLE", "TABLE") { |t|    $options[:table] = t }
  opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!

(puts "Please specify a table name to print.\n" << opt.help; 
  exit) unless $options[:table]
(puts "Please specify a database to print.\n" << opt.help; 
  exit) unless $options[:database]

$options[:hostname] ||= 'localhost'
$options[:username] ||= 'root'
$options[:password] ||= ''
$options[:port] ||= 3306

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => $options[:hostname],
  :username => $options[:username],
  :password => $options[:password],
  :database => $options[:database])

class OutputTable <  ActiveRecord::Base
  set_table_name $options[:table]
end

context={:table=> OutputTable, :print_data=>OutputTable.find_all}

eruby_object= Erubis::Eruby.new(File.read('template.rhtml'))

puts eruby_object.evaluate(context)

