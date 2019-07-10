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

get "/signup" do
 erb :'users/signup'
end

post "/signup" do
  fname = params[:first_name]
  fname.gsub!(/[0-9A-Za-z']/, '')
  lname = params[:last_name]
  lname.gsub!(/[0-9A-Za-z']/, '')
  uname = params[:user_name]
  uname.gsub!(/[^0-9A-Za-z_]/, '')
  email = params[:email]
  email.gsub!(/[0-9A-Za-z@_]/, '')
  bday = params[:birthday]
  bday.gsub!(/[^0-9A-Za-z]/, '')
  pword = params[:password]
  pword.gsub(/[<>]/, '')
  for each in params
    if each[1] == ''
      redirect '/signup'
    end
  end
  @user = User.new(first_name: fname, last_name: lname, user_name: uname, birthday: bday, email: email, password: pword)
  @user.save
  p "#{@user.first_name} was saved to the Database!"
  redirect '/thanks'
end

get '/search' do
  searchResults = User.find_by email: 'example%'
  p searchResults
end

get '/login' do
  if session[:user_id]
    redirect '/'
  end
  erb :'users/login'
end

post '/login' do
  given_password = params['password']
  user = User.find_by(email: params['email'])
  if user
    if user.password == given_password
      p "User Authenticated Successfully!"
      session[:user_id] = user.id
    else
      p "Invalid Password"
    end
  end
end

# DELETE request
post '/logout' do
  session.clear
  p "User Logged out Successfully"
  redirect '/'
end

get '/thanks' do
  erb :thanks
end
