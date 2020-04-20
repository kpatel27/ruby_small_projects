INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

def prompt(message)
  puts "=> #{message}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system('clear') || system('clr')
  puts "You are 'X', Computer is 'O'"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  (1..9).each_with_object({}) { |num, hash| hash[num] = INITIAL_MARKER }
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt("Choose a square: #{joinor(empty_squares(brd))}:")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).all?(PLAYER_MARKER)
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).all?(COMPUTER_MARKER)
      return 'Computer'
    end
  end
  nil
end

def increment_score(score, brd)
  winner = detect_winner(brd)
  winner == 'Player' ? score[:player] += 1 : score[:computer] += 1
end

def joinor(options, delimiter = ', ', conjunction = 'or')
  case options.size
  when 1 then options.first
  when 2 then options.join(" #{conjunction} ")
  else
    options[-1] = "#{conjunction} #{options.last} "
    options.join(delimiter)
  end
end

prompt("Welcome to Ultimate TTT! First to 5 Wins!")

loop do
  score = { player: 0, computer: 0 }

  loop do
    board = initialize_board
    display_board(board)

    prompt("Score: Player #{score[:player]} - #{score[:computer]} Computer")

    loop do
      player_places_piece!(board)
      display_board(board)
      break if board_full?(board) || someone_won?(board)
      computer_places_piece!(board)
      display_board(board)
      break if board_full?(board) || someone_won?(board)
    end

    if someone_won?(board)
      prompt("#{detect_winner(board)} won!")
      increment_score(score, board)
    else
      prompt("It's a tie!")
    end

    break if score.values.any?(5)
  end

  prompt('Play again? (yes or no)')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
