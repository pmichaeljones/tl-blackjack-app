require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  erb :welcome
end

post '/start_game' do
  session[:username] = params[:username]
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(cards)
  3.times { session[:deck].shuffle! }

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop

  erb :betting_form
end

get '/player_profile' do
  erb :"/PlayerViews/player_profile"
end

get '/player_hit' do
  session[:player_cards] << session[:deck].pop
  erb :betting_form
end

get '/player_stay' do
  erb :betting_form
end




