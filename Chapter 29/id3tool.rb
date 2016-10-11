require 'id3lib'
require 'optparse'

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
    opts.on_tail("-h",
                  "--help", "Show this message") {
                     puts opts.help; exit }

end
opt.parse!

# IF they didn't specify at least one file,
# display a brief message and exit.

(puts "Please specify one or more mp3 files to work with.";
       exit) unless ARGV.length > 0
# Loop through all of the files on the command
# line...
ARGV.each do |file|
  # .. read their tags...
  tag = ID3Lib::Tag.new(file)
  # ... display the info we found...
  display= "#{file} - #{tag.title} from #{tag.album} by #{tag.artist}"

  # ... update the info if necessary...
  if $options[:set].length>0
    $options[:set].each { |key, value| tag.send("#{key}=",value) }
    tag.update!
    display << " ...updating... "
  end

  # ... and finally print out the result.
  puts display
end

