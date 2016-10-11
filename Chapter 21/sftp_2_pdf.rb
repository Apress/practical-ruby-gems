require 'pdf/writer'
require 'net/sftp'
require 'optparse'

options = {}
opt=OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] hostname.com " << 
                  "directory1 directory 2 directory3..."

  opts.on("-u", "--username USERNAME", "username") { |u|    options[:username] = u }
  opts.on("-p", "--password PASSWORD", "password") { |p|    options[:password] = p }
  opts.on("-o", "--port PORT", "port") { |p|    options[:port] = p }
  opts.on("-O", "--order FIELDNAME", "fieldname") { |f|    options[:sortcolumn] = f }
  opts.on("-s", "--sort ASC_OR_DESC", "sort") { |s|    options[:sortorder] = s }
  opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!

options[:hostname] = ARGV.shift
options[:directories] = ARGV
options[:username] ||= 'root'
options[:password] ||= ''
options[:sortcolumn] ||= 'filename'
options[:port] ||= 25

pdf_document = PDF::Writer.new

# Connect to the server specified on the command line.

Net::SFTP.start(options[:hostname],
    :port=>options[:port],
    :username=>options[:username],
    :password=>options[:password]) do |sftp_connection|

  options[:directories].each do |directory|
    pdf_document.select_font "Times-Roman"
    pdf_document.text "Directory #{directory} on " << 
                      "host #{options[:hostname]}", :font_size=>32
    directory = sftp_connection.opendir(directory)
    files = sftp_connection.readdir(directory)

    # Build the table of data from the remote directory.

    table_data = []
    files.each do |file|
      table_data << {"filename"=>file.filename, 
                     "size"=> file.attributes.size, 
                     "mtime"=> file.attributes.mtime 
                    } unless file.filename =~ /^\.+$/
    end

    # Sort the data according to the options
    # specified on the command line.

    table_data.sort! do  |row1, row2|
      if options[:sortorder] == 'ASC'
        row1[options[:sortcolumn]] <=> row2[options[:sortcolumn]]
      else
        row2[options[:sortcolumn]] <=> row1[options[:sortcolumn]]
      end
    end

    # Format all of the dates.

    table_data.collect do |row|
      row["mtime"] = Time.at(row["mtime"]).strftime('%m/%d/%y')
    end

    pdf_document.move_pointer 20


    # Create the table.

    require 'PDF/SimpleTable'

    table= PDF::SimpleTable.new
    table.shade_color = Color::RGB::Grey90
    table.position = :left
    table.orientation = 30
    table.data = table_data
    table.column_order = ["filename", "size", "mtime"]
    table.render_on pdf_document

    pdf_document.move_pointer 50

  end
end

pdf_document.save_as "out.pdf"

