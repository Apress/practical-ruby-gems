require 'yahoofinance'
require 'fox16'
include Fox

# Exit if the user did not pass any symbols
# on the command line.
(puts "Usage: ruby #{$0} STOCK_SYMBOL STOCK_SYMBOL..."; exit) unless ARGV.length>0

# These values can be changed; they represent
# time in milliseconds.

@scroll_interval = 25
@update_interval = 6000

@fox_application=FXApp.new

@main_window=FXMainWindow.new(@fox_application, "Stock Ticker ", 
                              nil, nil, 
                              DECOR_ALL | LAYOUT_EXPLICIT)
@tickerlabel = FXLabel.new(@main_window, '', nil, 0,  LAYOUT_EXPLICIT)

# The following method updates the ticker text.
# It's called by a timer once a minute.

def update_label_text
  label_text = ' '
  # Loop through all of the symbols, retrieve
  # the most recent quotes, and update the
  # label with the most recent information.
  YahooFinance::get_standard_quotes( ARGV.join(',')).each do |symbol, qoute|
    label_text << "#{symbol}: #{qoute.lastTrade} ... "
  end
  @tickerlabel.text = label_text
end

# The following method scrolls the ticker accross
# the screen.
#
# It's called by a timer every 25ms.

def update_label_position

  @left_position = @tickerlabel.x if @left_position.nil?
  
  # Move the ticker back to the left once
  # it reaches the right edge.
  
  if(@left_position > @main_window.width)
    @left_position = -@tickerlabel.width
  end

  @left_position = @left_position + 3

  @main_window.padLeft = @left_position
end

update_label_text

@left_position=nil

# These following two functions manage 
# the timing of the update and scroll
# functions; FOX doesn't have a permanent
# timer - just one-shot timeouts - so 
# every time one of these functions is called,
# we need to set the timeout again.
#
def scroller(sender, sel, ptr)  
  update_label_position
  @fox_application.addTimeout(@scroll_interval, method(:scroller)) 
end

def updater(sender, sel, ptr)
  update_label_text
  @fox_application.addTimeout(@update_interval, method(:updater)) 
end

# Initialize the two timer functions...

@fox_application.addTimeout(@scroll_interval, method(:scroller)) 
@fox_application.addTimeout(@update_interval, method(:updater)) 


# Create the window, show it, 
# and then run the application.

@fox_application.create

@main_window.show( PLACEMENT_SCREEN )

@fox_application.run

