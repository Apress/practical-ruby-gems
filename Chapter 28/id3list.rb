require 'id3lib'
require 'optparse'
require 'memoize'

include Memoize

$options = {}
$options[:set]={}

opt=OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} directory_name OPTIONS... "

    opts.on("-s", "--sort OPTION=VALUE", "Sorts by the given ID3.") do |sort|
      $options[:sort] = sort

    end
    opts.on("-d", "--do-not-memoize", "Turns off memoization.") do |sort|
      $options[:do_not_memoize] = true

    end  
    opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!

(puts "Please specify a directory of mp3 files to work with."; 
       exit) unless ARGV.length == 1

def get_file_id3_value(file, tag_name)
  tag = ID3Lib::Tag.new(file)
  tag.send(tag_name)
end

def get_file_display_name(file)
  tag = ID3Lib::Tag.new(file)
  return "<p><i>#{tag.title}</i> from <i>#{tag.album}</i> by " <<
         "#{tag.artist}<br><small><a href='#{file}'>#{file}</a></small></p>"
end

list_of_mp3_files = Dir.glob("#{ARGV[0]}/*.mp3")


memoize :get_file_id3_value unless $options[:do_not_memoize]

list_of_mp3_files.sort! do |a,b|
  get_file_id3_value(a, $options[:sort] ).to_s <=> 
      get_file_id3_value(b, $options[:sort] ).to_s
end

puts "<html><body>"

list_of_mp3_files.each do |file|
  puts get_file_display_name(file)
end

puts "</html></body>"

