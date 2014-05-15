require 'rubygems'
require 'sinatra'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MUST_HIT = 16

before do

@action_buttons = true

end

### HELPERS START ###
helpers do

  def calculate_total(cards)
    arr = cards.map{ |e| e[1] }

    total = 0

    arr.each do |value|
      if value == "Ace"
        total += 11
      elsif value.to_i == 0
        total += 10
      else
        total += value.to_i
      end
    end

    arr.select{|e| e == "Ace"}.count.times do
      total -= 10 if total > BLACKJACK_AMOUNT
    end

    total

  end

  def card_image(array)
    file_path = ""
    file_path = "<img src=" + '"/images/cards/' + array[0].to_s.downcase + "_" + array[1].to_s.downcase + '.jpg"' + "/>"
    file_path
  end

  def who_wins
  end


end

### HELPERS END ###

# Sinatra Routes in Pseudo-Code #

# Game loads and asks for player name
# Second page asks for player's bet amount from available total
# Deal cards. Back and forth action.
# Player hits or stays based on choice
# Dealer hits or stays based on logic
# Figure out who wins
# Adjust pot total based on win/lose/draw
# Ask if player wants to play again


get '/' do
  erb :player_name
end

post '/bet' do
  if params[:player].empty?
    @message = "You need to include a name, silly!"
    erb :player_name
  else
    session[:player] = params[:player]
    session[:pot] = 500
    @new_game = true
    erb :input_bet
  end

end

post '/game' do
  if params[:bet].to_i > session[:pot]
    @outcome_lose = "You Can't Bet More Than You Have."
    halt erb :input_bet
  elsif params[:bet].to_i == 0
    @outcome_lose = "You need to bet a number greater than 0."
    halt erb :input_bet
  else
    session[:bet] = params[:bet].to_i
    session[:pot] = session[:pot] - session[:bet]
  end

  suits = ["Hearts", "Spades", "Clubs", "Diamonds"]
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
  session[:deck] = suits.product(values).shuffle

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  session[:player_score] = calculate_total(session[:player_cards])

  if session[:player_score] == BLACKJACK_AMOUNT
    session[:pot] = session[:pot] + session[:bet] * 3
    @outcome_win = "You got BlackJack and won #{session[:bet] * 3}!"
    @action_buttons = false
    @play_again = true
  end


  erb :game
end

post '/player_hit' do
  session[:player_cards] << session[:deck].pop
  session[:player_score] = calculate_total(session[:player_cards])
  if session[:player_score] > BLACKJACK_AMOUNT
    @outcome_lose = "You Busted with a #{session[:player_score]}!"
    @action_buttons = false
    @play_again = true
  elsif session[:player_score] == BLACKJACK_AMOUNT
    session[:pot] = session[:pot] + session[:bet] * 3
    @outcome_win = "You got BlackJack and won #{session[:bet] * 3}!"
    @action_buttons = false
    @play_again = true
  end

  erb :game

end

post '/player_stay' do
  @dealer_show = true
  @action_buttons = false
  session[:dealer_score] = calculate_total(session[:dealer_cards])

  if session[:dealer_score] > DEALER_MUST_HIT && session[:dealer_score] > session[:player_score]
    @outcome_lose = "Dealer's #{session[:dealer_score]} beats #{session[:player]}'s #{session[:player_score]}. Dealer Wins."
    @play_again = true

  elsif session[:dealer_score] > DEALER_MUST_HIT && session[:dealer_score] == session[:player_score]
    @outcome_lose = "It's a Push at #{session[:dealer_score]}. House wins."
    @play_again = true

  elsif session[:dealer_score] > DEALER_MUST_HIT && session[:player_score] > session[:dealer_score]
    @outcome_win = "#{session[:player]}'s #{session[:player_score]} beat's the dealer's #{session[:dealer_score]}."
    @play_again = true
    session[:pot] = session[:pot] + session[:bet] * 2

  elsif session[:dealer_score] <= DEALER_MUST_HIT
    @dealer_turn = true
  end

  erb :game

end

post '/dealer_hit' do
  @dealer_show = true
  @action_buttons = false
  session[:dealer_cards] << session[:deck].pop
  session[:dealer_score] = calculate_total(session[:dealer_cards])

  if session[:dealer_score] > BLACKJACK_AMOUNT
    @outcome_win = "Dealer busted! #{session[:player]} wins!"
    session[:pot] = session[:pot] + session[:bet] *2
    @play_again = true

  elsif session[:dealer_score] > DEALER_MUST_HIT && session[:dealer_score] > session[:player_score]
    @outcome_lose = "Dealer's #{session[:dealer_score]} beats player's #{session[:player_score]}. Dealer Wins."
    @play_again = true

  elsif session[:dealer_score] > DEALER_MUST_HIT && session[:dealer_score] == session[:player_score]
    @outcome_lose = "It's a Push at #{session[:dealer_score]}. House wins."
    @play_again = true

  elsif session[:dealer_score] > DEALER_MUST_HIT && session[:player_score] > session[:dealer_score]
    @outcome_win = "#{session[:player]}'s #{session[:player_score]} beat's the dealer's #{session[:dealer_score]}."
    @play_again = true
    session[:pot] = session[:pot] + session[:bet] * 2

  elsif session[:dealer_score] <= DEALER_MUST_HIT
    @dealer_turn = true
  end

  erb :game

end


post '/play_again' do
  if session[:pot] == 0
    @good_terms = false
    halt erb :goodbye
  else
  erb :input_bet
  end

end

post '/end_game' do
  erb :goodbye
end

