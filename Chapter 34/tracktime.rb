# This file contains a single class that will let you
# start a TrackTime server easily.
#
# You can use this file as follows:
#
# require 'tracktime'
# TrackTimeServer.start
#
# You can also use it in a Ruby one-liner:
#
# ruby -e "require 'tracktime'; TrackTimeServer.start"
#
require "tracktime.rb"
require "mongrel"
class TrackTimeServer
	# Starts a TrackTime server on the specified interface,
	# port, and mountpoint.
	#
	# Note that since this joins the server thread to the current thread,
	# no code after this call will be executed.
	#
	def TrackTimeServer.start(interface='0.0.0.0', port=3000, mountpoint='tracktime')
		TrackTime::Models::Base.establish_connection :adapter => 'sqlite3',
			:database => 'tracktime.db'

		TrackTime::Models::Base.logger = Logger.new('tracktime.log')
		TrackTime.create

		@server = Mongrel::Camping::start(interface, port, "/#{mountpoint}", TrackTime)
		puts "**TrackTime is running on Mongrel - " <<
			"check it out at http://localhost:#{port}/#{mountpoint}"
		@server.run.join
	end
end

