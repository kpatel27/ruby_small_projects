require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_integer?(num)
  num.to_i.to_s == num
end

def valid_float?(num)
  num.to_f.to_s == num
end

def valid_number?(num)
  valid_integer?(num) || valid_float?(num)
end

def operation_to_message(operation)
  case operation
  when '1' then 'Adding'
  when '2' then 'Subtracting'
  when '3' then 'Multiplying'
  when '4' then 'Dividing'
  end
end

prompt(MESSAGES['welcome'])
name = ''

loop do
  name = gets.chomp
  break unless name.empty? || name.chars.all?(' ')
  prompt(MESSAGES['invalid_name'])
end

loop do
  num1 = ''
  num2 = ''

  prompt(MESSAGES['first_number'])

  loop do
    num1 = gets.chomp
    break if valid_number?(num1)
    prompt(MESSAGES['invalid_number'])
  end

  prompt(MESSAGES['second_number'])

  loop do
    num2 = gets.chomp
    break if valid_number?(num2)
    prompt(MESSAGES['invalid_number'])
  end

  prompt(MESSAGES['operator_prompt'])
  operator = ''

  loop do
    operator = gets.chomp
    break if %w(1 2 3 4).include?(operator)
    prompt(MESSAGES['invalid_operator'])
  end

  prompt("#{operation_to_message(operator)} the two numbers...")

  result = case operator
           when '1' then num1.to_f + num2.to_f
           when '2' then num1.to_f - num2.to_f
           when '3' then num1.to_f * num2.to_f
           when '4'
             if num2.to_i.zero?
               prompt(MESSAGES['zero_division'])
               next
             else
               num1.to_f / num2.to_f
             end
           end

  prompt("The result is #{result}")

  prompt("#{name}, #{MESSAGES['play_again?']}")
  answer = gets.chomp
  break if %w(no n).include?(answer.downcase)
  system('clear') || system('clr')
end
