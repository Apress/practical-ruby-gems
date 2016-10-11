require 'rwb'

number_of_runs=ARGV.shift.to_i

url_list = RWB::Builder.new()

url_list.add_url(1, 'http://localhost:3000/user/login')

tester = RWB::Runner.new(url_list, number_of_runs, 1)

tester.run
tester.report_header
tester.report_overall()

