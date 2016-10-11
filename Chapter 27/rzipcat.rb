(puts "usage: #{$0} zipfile [filename]
prints out one file or all files from a zip file"; exit) unless ARGV.length

zipfile=ARGV.shift
filename=nil
filename=ARGV.shift unless ARGV.length==0

def print_file(filename, fs)
    puts filename
    puts "=" * filename.length
    puts fs.file.read(filename)
end

# Open the zip file.

Zip::ZipFile.open(zipfile) do |fs|
  # If the user specified just one file,
  # print only that file.
  if filename
      print_file filename, fs
  else
    # If not, print all of the files.

    fs.dir.foreach('/') do |filename|
      print_file filename, fs
    end
  end

end

