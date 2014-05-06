require 'rubygems'
require 'sinatra'

set :sessions, true

### START METHODS ###
def calculate_total(cards)
  # [['H', '3'], ['S', 'Q'], ... ]
  arr = cards.map{|e| e[1] }

  total = 0
  arr.each do |value|
    if value == "ACE"
      total += 11
    elsif value.to_i == 0 # J, Q, K
      total += 10
    else
      total += value.to_i
    end
  end

  #correct for Aces
  arr.select{|e| e == "ACE"}.count.times do
    total -= 10 if total > 21
  end

  total
end

### END METHODS ###


### START SINATRA ROUTES ###

get '/' do
  erb :welcome
end

post '/start_game' do
  session[:username] = params[:username]

  if params[:new_bet]
    session[:bet] = params[:new_bet].to_i
    session[:chip_count] = session[:chip_count]
  else
    session[:bet] = params[:bet].to_i
    session[:chip_count] = 500
  end

  session[:chip_count] -= session[:bet]
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'JACK', 'QUEEN', 'KING', 'ACE']
  session[:deck] = suits.product(cards)
  3.times { session[:deck].shuffle! }

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_total] = calculate_total(session[:player_cards])
  session[:dealer_total] = calculate_total(session[:dealer_cards])

  erb :betting_form
end

get '/player_hit' do
  session[:player_cards] << session[:deck].pop
  session[:player_total] = calculate_total(session[:player_cards])
  erb :betting_form
end

get '/player_stay' do
  erb :player_staying
end

get '/dealer_turn' do
  dealer_hit(session[:dealer_cards], session[:deck], session[:dealer_total])
  session[:dealer_total] = calculate_total(session[:dealer_cards])
  erb :dealer_turn
end

get '/new_bet' do
  if session[:chip_count] <= 0
    erb :you_lose
  else
    erb :new_bet
  end

end

get '/play_again' do
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'JACK', 'QUEEN', 'KING', 'ACE']
  session[:deck] = suits.product(cards)
  3.times { session[:deck].shuffle! }

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_total] = calculate_total(session[:player_cards])
  session[:dealer_total] = calculate_total(session[:dealer_cards])

  erb :betting_form
end

get '/finish' do
  erb :end_game
end


### HELPERS START ###
helpers do
  def dealer_hit(cards, deck, score)
    while score < 17
      cards << deck.pop
      score = calculate_total(cards)
    end
    cards
  end

  def bust?(score)
    if score > 21
      true
    else
      false
    end

  end

require 'pry'

  def card_image(array)
    file_path = ""
    file_path = "<img src=" + '"/images/cards/' + array[0].to_s.downcase + "_" + array[1].to_s.downcase + '.jpg"' + "/>"
    file_path
  end


end


### HELPERS END ###



