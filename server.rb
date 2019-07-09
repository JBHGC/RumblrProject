require "sinatra"
require "sinatra/activerecord"

#LOCAL
# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './database.sqlite3')
#HEROKU
require "active_record"
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
# set :database, {adapter: "sqlite3", database: "./database.sqlite3"}

enable :sessions

class User < ActiveRecord::Base
end

get "/" do
  erb :home
end

get "/login" do
 erb :'users/login'
end

post "/login" do
  user = User.find_by(email: params[:email], password: params[:password])
  erb :'users/login'
end

get "/signup" do
 erb :'users/signup'
end

post "/signup" do
  user = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], username: params[:username], password: params[:password], )
  user.save
  redirect "/"
end

get "/search" do
  searchResults = User.find(email: 'ex')
  p searchResults
end
