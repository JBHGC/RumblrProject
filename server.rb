require "sinatra"
require "sinatra/activerecord"
require "active_record"

#LOCAL
# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './database.sqlite3')
# set :database, {adapter: "sqlite3", database: "./database.sqlite3"}
#HEROKU
# ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

if ENV['RACK_ENV']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end

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
  fname = params[:first_name]
  fname.gsub(/[<>]/,'')
  lname = params[:last_name]
  lname.gsub(/[<>]/,'')
  uname = params[:user_name]
  uname.gsub(/[<>]/,'')
  age = params[:age]
  age.gsub(/[<>]/,'')
  email = params[:email]
  email.gsub(/[<>]/,'')
  pword = params[:password]
  pword.gsub(/[<>]/,'')
  user = User.new(fname, lname, uname, age, email, pword)
  user.save
  redirect "/"
end

get "/search" do
  searchResults = User.find_by email: 'example%'
  p searchResults
end
