DEALER_LIMIT = 17
BLACKJACK = 21
ROUNDS_TO_WIN = 3

def prompt(message)
  puts "=> #{message}"
end

def pause
  sleep 1
end

def clear_screen
  system('clear') || system('clr')
end

def display_welcome
  clear_screen
  prompt("Welcome to 21! First to #{ROUNDS_TO_WIN} wins!")
  prompt("Press Enter to start!")
  gets
end

def display_score(score)
  clear_screen
  prompt("SCORE: Player #{score[:player]} - #{score[:dealer]} Dealer")
  puts "==============================="
end

def initialize_deck
  [:spades, :hearts, :clubs, :diamonds].each_with_object({}) do |suit, deck|
    deck[suit] = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  end
end

def shuffle!(game_deck)
  game_deck.each { |_, cards| cards.shuffle! }
end

def deal!(game_deck)
  hand = []
  2.times do
    # picks a random suit that still has values
    rnd_suit = game_deck.keys.select { |suit| !game_deck[suit].empty? }.sample
    hand << game_deck[rnd_suit].pop
  end
  hand
end

def total(hand)
  sum = 0

  hand.each do |card|
    sum += if card == "A"
             11
           elsif %w(J Q K).include?(card)
             10
           else
             card.to_i
           end
  end

  ace_correction(hand, sum)
end

def ace_correction(hand, sum)
  hand.count("A").times do
    sum -= 10 if sum > BLACKJACK
  end
  sum
end

def join(hand)
  case hand.size
  when 2 then "'#{hand.join("' and '")}'"
  else
    "'#{hand[0..-2].join("', '")}'" + ", and '#{hand[-1]}'"
  end
end

def display_hand(participant, hand)
  if participant == :player
    prompt("Your hand is #{join(hand)} for a total of #{total(hand)}")
  else
    prompt("Dealer has #{join(hand)} for a total of #{total(hand)}")
  end
end

def display_single_card(dealer_hand)
  prompt("Dealer has '#{dealer_hand.first}' face up.")
end

def blackjack_on_deal(player_hand, dealer_hand, score)
  if got_21?(player_hand) && got_21?(dealer_hand)
    prompt("Blackjack for both! It's a tie")
  elsif got_21?(player_hand)
    prompt("You got blackjack!")
    player_wins(score)
  elsif got_21?(dealer_hand)
    prompt("Sorry, dealer is dealt a blackjack")
    display_hand(:dealer, dealer_hand)
    dealer_wins(score)
  end
end

def got_21?(hand)
  total(hand) == BLACKJACK
end

def player_wins(score)
  score[:player] += 1
  prompt('You won this round!')
end

def dealer_wins(score)
  score[:dealer] += 1
  prompt('Dealer won this round')
end

def hit_or_stay
  answer = ''

  loop do
    answer = gets.chomp.downcase
    break if %w(hit stay h s).include?(answer)
    prompt("Invalid option. Type and enter 'h' to hit or 's' to stay")
  end
  answer
end

def busted?(hand)
  total(hand) > BLACKJACK
end

def hit!(hand, game_deck)
  random_suit = game_deck.keys.select { |suit| !game_deck[suit].empty? }.sample
  hand << game_deck[random_suit].pop
end

def announce_next_round
  prompt("Press Enter to start the next round")
  gets
end

def play_again?
  prompt("Type and enter 'n' to quit or anyother key to rechallenge dealer")
  answer = gets.chomp.downcase
  answer == 'n'
end

def announce_round_winner(player_hand, dealer_hand, score)
  if got_21?(dealer_hand)
    dealer_wins(score)
  elsif total(player_hand) > total(dealer_hand)
    player_wins(score)
  elsif busted?(dealer_hand)
    prompt('Dealer busted!')
    player_wins(score)
  elsif total(dealer_hand) > total(player_hand)
    dealer_wins(score)
  else
    prompt("It's a tie!")
  end
end

def game_over?(score)
  score.values.any?(ROUNDS_TO_WIN)
end

def announce_game_winner(score)
  if score[:player] == ROUNDS_TO_WIN
    prompt('You are the grand champion!!')
  else
    prompt('Dealer is the champion. Better luck next time.')
  end
end

def display_round_outcome(player_hand, dealer_hand, score)
  pause
  display_score(score)
  display_hand(:dealer, dealer_hand)
  pause
  display_hand(:player, player_hand)
  pause
  announce_round_winner(player_hand, dealer_hand, score)
  pause
end
# Main Loop
# ====================

loop do
  display_welcome
  score = { player: 0, dealer: 0 }

  loop do
    display_score(score)

    deck = initialize_deck
    shuffle!(deck)

    player_hand = deal!(deck)
    dealer_hand = deal!(deck)

    pause
    display_single_card(dealer_hand)
    pause
    display_hand(:player, player_hand)

    if got_21?(player_hand) || got_21?(dealer_hand)
      blackjack_on_deal(player_hand, dealer_hand, score)
      announce_next_round
      next
    end

    loop do
      pause
      prompt("Do you want to hit (h) or stay (s)?")
      answer = hit_or_stay

      if %w(s stay).include?(answer)
        prompt('You chose to stay!')
        pause
        break
      end

      display_score(score)
      display_single_card(dealer_hand)

      hit!(player_hand, deck)
      display_hand(:player, player_hand)

      break if busted?(player_hand) || got_21?(player_hand)
    end

    if busted?(player_hand)
      prompt('You busted!')
      dealer_wins(score)
      announce_next_round
      next
    elsif got_21?(player_hand)
      player_wins(score)
      announce_next_round
      next
    end

    prompt('Revealing dealers cards...')
    pause

    loop do
      break if total(dealer_hand) >= DEALER_LIMIT

      display_score(score)
      display_hand(:dealer, dealer_hand)

      prompt('Dealer hits...')
      pause

      hit!(dealer_hand, deck)
    end

    display_round_outcome(player_hand, dealer_hand, score)

    if game_over?(score)
      announce_game_winner(score)
      break
    end

    announce_next_round
  end

  answer = play_again?
  break if answer
end

prompt('Thanks for playing!')
