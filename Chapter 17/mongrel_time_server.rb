require 'mongrel'

class TimeHandler < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |headers, output_stream|
      headers["Content-Type"] = "text/plain"
      output_stream.write("My current time is #{Time.now}.\n")
    end
  end
end

puts "** Time server on Mongrel started!"

mongrel_server = Mongrel::HttpServer.new("0.0.0.0", "3000")
mongrel_server.register("/", TimeHandler.new)
mongrel_server.run.join

