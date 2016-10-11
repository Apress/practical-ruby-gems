require 'rmagick'
require 'markaby'
require 'optparse'

options = {}
opt=OptionParser.new do |opts|
  opts.banner = "Usage: #{$0}.rb [options] image_directory"

  opts.on("-u", "--thumbnail_directory directory", 
                "thumbnail_directory") { |u|   
                 options[:thumbnail_directory] = u }
  opts.on("-h", "--thumbnail_height HEIGHT", 
                "thumbnail_height") { |h|    
                 options[:thumbnail_height] = h.to_i }
  opts.on("-w", "--thumbnail_width WIDTH", 
                 "thumbnail_width") { |w|    
                 options[:thumbnail_width] = w.to_i }
  opts.on("-c", "--background_color COLOR", 
                "background_color") { |c|    
                 options[:background_color] = c }

  opts.on("-t", "--crop_top HEIGHT", "crop_vertical") { |ct|  
                 options[:crop_top] = ct.to_i }
  opts.on("-b", "--crop_bottom HEIGHT", "crop_bottom") { |cb|  
                 options[:crop_bottom] = cb.to_i }

  opts.on("-l", "--crop_left WIDTH", "crop_left") { |cl|  
                 options[:crop_left] = cl.to_i }
  opts.on("-r", "--crop_right WIDTH", "crop_right") { |cr|  
                 options[:crop_right] = cr.to_i }

  opts.on_tail("-h", "--help", "Show this message") { puts opts.help; exit }

end
opt.parse!


( puts opt.help; exit ) unless ARGV.length==1
options[:directory] = ARGV.shift 
options[:thumbnail_directory] ||= "#{options[:directory]}/thumbnails"
options[:thumbnail_height] ||= 64
options[:thumbnail_width] ||= 64
options[:background_color] ||= 'black'


background = Magick::Image.new(options[:thumbnail_height],
                               options[:thumbnail_width]) do
  self.background_color=options[:background_color]
end

Dir.mkdir(options[:thumbnail_directory]) unless 
          File.exists?(options[:thumbnail_directory])

html=Markaby::Builder.new

html.html do
  html.head do
    html.title "Picture Index for #{options[:directory]}"
  end
  html.body do

    Dir.foreach(options[:directory]) do |file|

      # Manipulate the files only if they are images.

      if file =~ /.*\.(jpg|gif|bmp|png|tif|tga)$/i 

        full_filename= "#{options[:directory]}/#{file}"
        thumbnail_filename= "#{options[:thumbnail_directory]}/#{file}"
        
        # Read the image from the disk.

        image= Magick::Image.read(full_filename).first
        
        # Crop the image if any of the crop options were specified
        # on the command line.

        image.crop!(Magick::SouthGravity, image.columns, image.rows - 
                    options[:crop_top]) unless options[:crop_top].nil?
        image.crop!(Magick::NorthGravity, image.columns, image.rows - 
                    options[:crop_bottom]) unless options[:crop_bottom].nil?

        image.crop!(Magick::WestGravity, image.columns - options[:crop_right],
                   image.rows) unless options[:crop_right].nil?
        image.crop!(Magick::EastGravity, image.columns - options[:crop_left], 
                    image.rows) unless options[:crop_left].nil?

        # Perform the actual resizing.

        image.change_geometry(
          "#{options[:thumbnail_width]}x" << 
          "#{options[:thumbnail_height]}") do |cols, rows, img|

            img.resize!(cols, rows)

            composite= background.composite(img, Magick::CenterGravity, 
                                            Magick::OverCompositeOp )
            composite.write thumbnail_filename
        end

        # Add a div to our output HTML which 
        # displays our new thumbnail.

        html.div :style=>"padding:1em; float:left; text-align:center" do 
          a :href=>full_filename do
            html.img :src=>thumbnail_filename, :align=>:center
          end
          p  do
            small file
          end
        end

      end
    end
  end
end

print html.to_s

