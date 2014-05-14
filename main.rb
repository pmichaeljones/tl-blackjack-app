require 'rubygems'
require 'sinatra'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MUST_HIT = 16

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
  session[:bet] = params[:bet].to_i
  session[:pot] = session[:pot] - session[:bet]

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

  erb :game
end

post '/player_hit' do
  session[:player_cards] << session[:deck].pop
  session[:player_score] = calculate_total(session[:player_cards])
  @dealer_turn = true
  erb :game
end


























