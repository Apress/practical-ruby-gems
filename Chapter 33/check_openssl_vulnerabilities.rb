require 'xmlsimple'
require 'net/http'
require 'yaml'

# If they did not specify a version to search
# for, exit with a brief message.
(puts "usage: #{$0} version" ; exit ) if ARGV.length!=1

my_version=ARGV[0]

# This is the URL where we are going to 
# download the vulnerability list.

url='http://www.openssl.org/news/vulnerabilities.xml'

# Next, we actually download the file 
# and save the results in the data variable.

xml_data = Net::HTTP.get_response(URI.parse(url)).body
data = XmlSimple.xml_in(xml_data)

data['issue'].each do |vulnerability|
  outstring=''
  affected=false
  # If the vulnerability affects at least one
  # openSSL version - which should always
  # be true, but we check just in case.

  if vulnerability['affects'] 
    vulnerability['affects'].each do |affected|
      if affected['version']==my_version
        affected=true 
        # If it affects our version, we'll
        # print it out below.
      end
    end
  end

  if affected
    (outstring << 
      "from #{vulnerability['reported'][0]['source']} " 
    ) unless vulnerability['reported'].nil?

    (outstring << 
       "at #{vulnerability['advisory'][0]['url']} "
    ) unless vulnerability['advisory'].nil?
  end

  # If we have something to print out, then
  # print it out.

  puts "Advisory #{ outstring}" unless outstring==''
end

