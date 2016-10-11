require 'net/sftp'
require 'optparse'

options = {}
opt=OptionParser.new do |opts|
  opts.banner = "Usage: netsftpput.rb [options] hostname.com file1 file2 file3..."

  opts.on("-u", "--username USERNAME", "username") { |u|    options[:username] = u }
  opts.on("-p", "--password PASSWORD", "password") { |p|    options[:password] = p }
  opts.on("-o", "--port PORT", "port") { |p|    options[:port] = p }
  opts.on("-d", "--director DIRECTORY", "directory") { |d|  
                                      options[:directory] = d }
  opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!

options[:hostname] = ARGV.shift
options[:username] ||= 'root'
options[:password] ||= ''
options[:port] ||= 25
options[:directory] ||= '/tmp'

Net::SFTP.start(options[:hostname],  
               :port=>options[:port],                
               :username=>options[:username],
               :password=>options[:password]) do |sftp_connection|
  ARGV.each do |filename|
    sftp_connection.put_file filename, "#{options[:directory]}/#{filename}"
  end
end

