require 'feed_tools'
require 'cmdparse'
require 'date'
require 'uri'

# Create a new CmdParse object -
# we're going to use this to parse
# our command line arguments.

cmd = CmdParse::CommandParser.new( true, true )
cmd.program_name = "jobsearch "
cmd.program_version = [0, 1, 0]

# These are two commands that come with CmdParse -
# the first displays a list of commands, and the
# second displays the current program version.

cmd.add_command( CmdParse::HelpCommand.new, true )
cmd.add_command( CmdParse::VersionCommand.new )

# This object will represent our first command -
# - the indeed command, which searches Indeed.com

indeed = CmdParse::Command.new('indeed', false )
indeed.short_desc = "Searches for jobs via Indeed.com "
indeed.short_desc  << " and prints the top ten results."

indeed.description = 'This command searches Indeed.com for jobs matching [ARGS].'
indeed.description << 'You can specify a location to search via '
indeed.description << 'the -l and -r switches.'

# This block of code sets the optional switches for our command.
indeed.options = CmdParse::OptionParserWrapper.new do |opt|
  opt.on( '-l', '--location LOCATION', 
  'Show jobs from LOCATION only' ) { |location| $location=location }
  opt.on( '-r', '--radius RADIUS', 
    'Sets a distance in miles from LOCATION to search from. ' <<
    'This option has no effect ' <<
    'without the -l option.' ) { |radius| $radius=radius }

end

# This block sets the code which will be executed when the
# command is run.

indeed.set_execution_block do |args|
  search_string= args.join(' ')
  feed_url = 'http://rss.indeed.com/rss?'
  feed_url << 'q=#{URI.escape(search_string)}'
  feed_url << '&l=#{$location}&sort=date&radius=#{$radius}'
  puts "Jobs matching \"#{search_string}\" from indeed.com"
  puts "for more detail, see the following URL:\n\t#{feed_url}\n\n"

  feed= FeedTools::Feed.open(feed_url)
  feed.items.each do |item|
    puts "#{item.title}"
  end
end

# This is similar to the previous command, but
# searchs jobs.coolruby.com.

coolruby = CmdParse::Command.new( 'coolruby', false )
coolruby.short_desc = "Shows Ruby jobs from jobs.coolruby.com"
coolruby.description = "This command takes no arguments."
coolruby.set_execution_block do |args|
  feed_url = "http://jobs.coolruby.com/rss"
  puts "Jobs from coolruby.com"
  puts "for more detail, see jobs.coolruby.com.\n"

  feed= FeedTools::Feed.open(feed_url)
  feed.items.each do |item|
    puts "#{item.title}"
  end
end

# This final command searches Craigslist sites.

craigslist = CmdParse::Command.new( 'craigslist', false )
craigslist.short_desc = "Searches all Craigslist sites for jobs"
craigslist.description = "Displays results from all craigslist sites which "
craigslist.description  << " match [ARGS]. Only displays recent results - "
craigslist.description  << " by default, results from the last "
craigslist.description  << " thirty days, but this can be overridden "
craigslist.description  << " with the -d option."

craigslist.options = CmdParse::OptionParserWrapper.new do |opt|
  opt.on( '-d', '--days DAYS', 
  'Show jobs from last DAYS days only' ) { |days| $days=days }
  opt.on( '-s', '--section SECTION', 
    'Show jobs from SECTION section of craigslist only. ' << 
    'cpg searches computer gigs, for example, ' <<
    'and sof searches software jobs.' ) { |section| $section=section }

end
craigslist.set_execution_block do |args|
  search_string= args.join(' ')
  $days||=30
  
  query_string = "#{search_string}"
  query_string << " site:craigslist.org"
   query_string << " inurl:/#{$section}/" unless $section.nil?

   query_string << " daterange:#{(Date.today-$days.to_i).jd}-#{Date.today.jd}"
  
    google_url="http://www.google.com/search?q=#{URI.encode(query_string)}"

  puts "Jobs matching \"#{search_string}\" in the last "
  puts #{$days} days from all craigslist via google.com"
  puts "You can use the following Google search string:"
  puts "\t#{query_string}"
  puts "You can also use the following URL:"
  puts "\t#{google_url}"
  
end

# We've created the command objects, but we haven't added
# them to our parser, so we'll do that next:

cmd.add_command( indeed )
cmd.add_command( coolruby )
cmd.add_command( craigslist )

# Finally, we need to actually parse the command.
# This runs the commands indicated
# on the command line

cmd.parse

