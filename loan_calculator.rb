=begin

UNDERSTANDING THE PROBLEM
=========================
Input: loan amount(integer or float)
       annual percentage rate(APR)(integer or float)
       loan duration(integer)

Output: monthly loan payments(float)

EXAMPLES / TEST CASES
========================
loan_amount: 5000, loan_in_months: 60, APR: 4.5% = monthly_payments: 93.22
loan_amount: 1000, loan_in_months: 12, APR: 1% = monthly_payments: 83.79
loan_amount: 1000000, loan_in_months: 1, APR: 3.2% = monthly_payment: 1002666.67

ALGORITHM
==========

START

ASSIGN loan_amount to user input for loan amount
VALIDATE loan_amount
  -check if loan amount is an integer or float greater than 0
ASSIGN apr to user input for apr
VALIDATE apr
  - check if apr is a float or integer greater than 0%
ASSIGN loan_duration to user input for loan_duration
VALIDATE loan_duration
  - check if loan_duration is an integer greater than or equal to 1 month
ASSIGN monthly_payments to m = p * (j / (1 - (1 + j)**(-n)))
  -m = monthly payment
  -p = loan amount
  -j = monthly interest rate
    - ASSIGN monthly_interest_rate to (apr / 12)
  -n = loan duration in months

END

=end

require 'yaml'
MESSAGES = YAML.load_file('loan_calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_integer?(num)
  num.to_i.to_s == num
end

def valid_float?(num)
  # checks if the string is empty or only consists of '.'
  return false if num.empty?
  return false if num == '.'
  return false if num.count('.') > 1

  # validates floats such as 2.5, 2. or .25
  valid_digits = ('0'..'9').to_a + ['.']
  num.chars.each { |digit| return false unless valid_digits.include?(digit) }

  true
end

def retrieve_name
  name = ''
  loop do
    name = gets.chomp.capitalize
    break unless name.empty? || name.chars.all?(' ')

    prompt(MESSAGES['invalid_name'])
  end
  name
end

def retrieve_loan_amount
  prompt(MESSAGES['enter_loan_amount'])
  loan_amount = ''

  loop do
    loan_amount = gets.chomp

    break if valid_loan_amount?(loan_amount)

    prompt(MESSAGES['invalid_loan_amount'])
  end
  loan_amount
end

def retrieve_apr
  prompt(MESSAGES['enter_apr'])
  apr = ''

  loop do
    apr = gets.chomp
    apr = apr[0..-2] if apr[-1] == '%'

    break if valid_apr?(apr)

    prompt(MESSAGES['invalid_apr'])
  end
  apr
end

def retrieve_loan_duration
  prompt(MESSAGES['enter_loan_duration'])
  loan_duration = ''

  loop do
    loan_duration = gets.chomp

    break if valid_loan_duration?(loan_duration)

    prompt(MESSAGES['invalid_loan_duration'])
  end
  loan_duration
end

def display_loan_confirmation(amount, interest, duration)
  prompt(MESSAGES['inputs'])
  prompt("Loan Amount: $#{amount}")
  prompt("APR: #{interest}%")
  prompt("Loan Duration: #{duration} months")
  prompt(MESSAGES['confirmation'])
end

def display_loan_results(amount, interest, duration)
  prompt(MESSAGES['calculating'])

  monthly_payments = monthly_loan_payments(amount, interest, duration)

  prompt("Your monthly payments are $#{monthly_payments}")
end

def valid_number?(num)
  valid_integer?(num) || valid_float?(num)
end

def valid_loan_amount?(loan)
  valid_number?(loan) && loan.to_f.positive?
end

def valid_apr?(apr)
  valid_number?(apr) && apr.to_f.positive?
end

def valid_loan_duration?(months)
  valid_integer?(months) && months.to_i.positive?
end

def monthly_loan_payments(amount, apr, months)
  amount = amount.to_f
  monthly_rate = apr.to_f / 100 / 12
  months = months.to_i

  monthly_payments = amount * monthly_rate / (1 - (1 + monthly_rate)**-months)
  format('%.2f', monthly_payments)
end

system('clear') || system('clr')

prompt(MESSAGES['welcome'])

name = retrieve_name

loop do
  system('clear') || system('clr')

  loan_amount = retrieve_loan_amount

  apr = retrieve_apr

  loan_duration = retrieve_loan_duration

  display_loan_confirmation(loan_amount, apr, loan_duration)

  answer = gets.chomp
  next if %w(no n).include?(answer.downcase)

  display_loan_results(loan_amount, apr, loan_duration)

  prompt("#{name}, #{MESSAGES['calculate_again']}")
  answer = gets.chomp

  break if %w(no n).include?(answer.downcase)
end
