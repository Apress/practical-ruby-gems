%w(rubygems camping tidy).each { |lib| require lib }

#
# Set the path for our Tidy DLL or .so file.
#
# The default here is for a DLL in the current directory under Windows;
# If you've put it elsewhere, you'll need to enter the value in the line below.
#
# Under Linux or Mac OS X, you can use the command 'locate libtidy.so'
# to retreieve the path to Tidy.
#

Tidy.path = './tidy.dll'

Camping.goes :WebTidy

module WebTidy::Controllers

  #
  # Homepage for the application.
  #
  class Index < R '/'
    def get
      if @input[:html]
        @html_output= Tidy.open('indent'=>'auto') do |tidy|
          tidy.clean(@input[:html])
        end
      end
      render :homepage
    end
  end

end

#
# Contains all of the views for the application.
#

module WebTidy::Views
  TIME_FORMAT="%H:%M:%S"

  #
  # View which shows the homepage.
  #

  def homepage
    p 'Input Text:'
    form do
      textarea  @input[:html], :cols=>45, :rows=>5, :name=>:html
      br :clear=>:left
      input :type=>:submit, :value=>'Send'
    end

    if @html_output
       textarea @html_output, :cols=>45, :rows=>5, :name=>:html
    end
  end

  def layout
    html do
      head do
        title 'WebTidy'
      end
      body do
        h1 "welcome to webtidy"
        div.content do
          self << yield
        end
      end
    end
  end
end

