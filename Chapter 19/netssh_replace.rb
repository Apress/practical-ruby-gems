require 'net/ssh'
require 'optparse'

# This use of OptionParser lets the user
# specify the username, password, and port
# options on the command line.

options = {}
opt=OptionParser.new do |opts|
  opts.banner = "Usage: net_ssh_replace.rb [options] " <<
                "hostname.com file search_string replacement_string"

  opts.on("-u", "--username USERNAME", "username") { |u|    options[:username] = u }
  opts.on("-p", "--password PASSWORD", "password") { |p|    options[:password] = p }
  opts.on("-o", "--port PORT", "port") { |p|    options[:port] = p }
  opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!

# Exit if the user didn't specify enough
# command line arguments.

( puts opt.help; exit ) unless ARGV.length == 4

options[:hostname] = ARGV.shift
options[:filename] = ARGV.shift
options[:search_string] = ARGV.shift
options[:replacement_string] = ARGV.shift

options[:username] ||= 'root'
options[:password] ||= ''
options[:port] ||= 22

# Create a new SSH connection.

Net::SSH.start(options[:hostname],
    :port=>options[:port],
    :username=>options[:username],
    :password=>options[:password]) do |ssh_connection|
# Open a channel for I/O.

  ssh_connection.open_channel do |channel|

  # Execute our command.

  channel.exec "vim #{options[:filename]} -c '%s/#{options[:search_string]}/" << 
               "#{options[:replacement_string]}/g' -c 'wq!' "
  end

  # Wait for our command to finish.

  ssh_connection.loop
end

