require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  erb :welcome
end

post '/set_name' do
  session[:username] = params[:username]
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(cards)
  session[:deck].shuffle!

  session[:player_cards] = session[:deck].pop(2)

  erb :betting_form
end

get '/player_profile' do
  erb :"/PlayerViews/player_profile"
end




