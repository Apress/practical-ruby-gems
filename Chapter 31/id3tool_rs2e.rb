require 'id3lib'
require 'optparse'
require 'rubyscript2exe'

exit if RUBYSCRIPT2EXE.is_compiling?

$options = {}
$options[:set]={}

opt=OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} file1 file2 file3... "

    opts.on("-s", "--set OPTION=VALUE",
            "Sets the ID3 option OPTION to VALUE.") do |options|
      option, value = options.split(/=/)
      (puts 'Please set the ID3 in the format option=value.';
            exit) unless option and value
      $options[:set][option] = value

    end
    opts.on_tail("-h", "--help",
                 "Show this message") { puts opts.help; exit }

end
opt.parse!

(puts "Please specify one or more mp3 files to work with.";
       exit) unless ARGV.length > 0
ARGV.each do |file|
  tag = ID3Lib::Tag.new(file)

  display= "#{file} - #{tag.title} from #{tag.album} by #{tag.artist}"

  if $options[:set].length>0
    $options[:set].each { |key, value| tag.send("#{key}=",value) }
    tag.update!
    display << " ...updating... "
  end

  puts display
end

