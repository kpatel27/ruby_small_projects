WINNING_SCORE = 5
CHOICES = %w(rock paper scissors lizard spock).freeze
CHOICES_ABBRV = %w(r p s l sp).freeze
WIN_CONDITIONS = {
  rock: %w(scissors lizard),
  paper: %w(rock spock),
  scissors: %w(paper lizard),
  lizard: %w(spock paper),
  spock: %w(rock scissors)
}.freeze

# METHODS
# =================================
def prompt(message)
  puts "=> #{message}"
end

def win?(player, computer)
  WIN_CONDITIONS[player.to_sym].include?(computer)
end

def display_result(first, second)
  if first == second
    prompt("It's a tie")
  elsif win?(first, second)
    prompt('You won!')
  else
    prompt('Computer won')
  end
end

def winner?(score)
  score[:player] == WINNING_SCORE || score[:computer] == WINNING_SCORE
end

def score_increment(player, computer, score)
  score[:player] += 1 if win?(player, computer)
  score[:computer] += 1 if win?(computer, player)
end

def display_options
  options = <<-MSG
    1) 'rock' or 'r'
    2) 'paper' or 'p'
    3) 'scissors' or 's'
    4) 'lizard' or 'l'
    5) 'spock' or 'sp'
  MSG

  prompt('Choose one:')
  prompt(options.strip)
end

def abbreviated_choice(choice)
  case choice
  when 'r' then 'rock'
  when 'p' then 'paper'
  when 's' then 'scissors'
  when 'l' then 'lizard'
  when 'sp' then 'spock'
  else choice
  end
end

def choose_option
  choice = ''

  loop do
    choice = gets.chomp.downcase

    break if CHOICES.include?(choice) || CHOICES_ABBRV.include?(choice)

    prompt('Not a valid choice')
  end
  abbreviated_choice(choice)
end

def display_winner(score)
  if score[:player] == WINNING_SCORE
    prompt('YOU ARE THE GRAND CHAMPION!!!')
  elsif score[:computer] == WINNING_SCORE
    prompt('Computer won, better luck next time!')
  end
end

def play_again?
  prompt("Do you want to play again? Enter 'yes' or 'no'.")
  answer = ''

  loop do
    answer = gets.chomp
    break if %w(yes no).include?(answer)
    prompt('Not a valid answer')
  end

  answer == 'yes'
end

def display_welcome
  prompt('Welcome to the Advanced Version of the Classic RPS Game!')
  prompt("First to reach #{WINNING_SCORE} wins is the GRAND WINNER!")
end
# Main loop
# ===============================

loop do
  system('clear') || system('clr')
  display_welcome

  score = { player: 0, computer: 0 }

  loop do
    display_options
    player_choice = choose_option
    computer_choice = CHOICES.sample

    system('clear') || system('clr')

    prompt("You chose: #{player_choice}; Computer chose: #{computer_choice}")

    display_result(player_choice, computer_choice)
    score_increment(player_choice, computer_choice, score)
    prompt("SCORE: Player #{score[:player]} - Computer #{score[:computer]}")

    display_winner(score)
<<<<<<< HEAD
    break if score.values.any?(5)

    system('clear') || system('clr')
=======
    break if score.values.any?(WINNING_SCORE)
>>>>>>> da5c0169aa8ce28b1dda9391c9f74db16601ba4e
  end

  break unless play_again?
end

prompt('Thank you for playing. Good bye!')
