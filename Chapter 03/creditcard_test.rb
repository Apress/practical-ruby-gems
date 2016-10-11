require 'creditcard'
if ARGV[0]
	credit_card_number=ARGV[0]
	if credit_card_number.creditcard?
		puts "Credit card number is valid " <<
			 "with type #{credit_card_number.creditcard_type}."
	else
		puts "Credit card number is not valid."
	end
else
	puts "Please enter a valid credit card number."
end

