require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  erb :welcome
end

post '/set_name' do
  session[:username] = params[:username]
  erb :betting_form
end

get '/player_profile' do
  erb :"/PlayerViews/player_profile"
end




