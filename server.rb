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

class Post < ActiveRecord::Base
end
@@all_recent_posts = Post.last(20)

get "/" do
  for every in @@all_recent_posts
    if every
      every.title.gsub(/[']/, '"')
      every.content.gsub(/[']/, '"')
      every.tags.gsub(/[']/, '"')
    else
      break
    end
  end
  p @all_recent_posts
  erb :home
end

get "/signup" do
  if session[:user_id]
    redirect '/'
  end
 erb :'users/signup'
end

post "/signup" do
  fname = params[:first_name]
  fname.gsub(/[<>!@#$%^&*()-=+]/, '')
  lname = params[:last_name]
  lname.gsub(/[<>!@#$%^&*()-=+]/, '')
  uname = params[:user_name]
  uname.gsub(/[<>@#&]/, '')
  email = params[:email]
  email.gsub(/[<>!#$%^&*()=+]/, '')
  bday = params[:birthday]
  pword = params[:password]
  for each in params
    p each
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
  p 'Nothing was Searched'
  redirect '/'
end

post '/search' do
  if params[:searchtext] == ''
    redirect '/search'
  else
    searchtext = params[:searchtext]
    searchtext.gsub(/[;!*(){}<>s+]/, '')
    search_results = Post.where('tags LIKE ?', "%#{searchtext.downcase}%")
    p searchtext
  end
end

get '/login' do
  if session[:user_id]
    redirect '/'
  end
  erb :'users/login'
end

post '/login' do
  if User.find_by(email: params['email'], password: params['password'])
    user = User.find_by(email: params['email'], password: params["password"])
    p "User Authenticated Successfully!"
    session[:user_id] = user.id
    redirect '/'
  else
    p "Wrong Username/Password"
  end
end

get '/logout' do
  session.clear
  p "User Logged out Successfully"
  redirect '/'
end

get '/thanks' do
  erb :thanks
end

get '/createpost' do
  if session[:user_id]
    erb :createpost
  else
    redirect '/login'
  end
end

post '/createpost' do
  count = 0
  for each in params
    if each[1] != ""
      count = count + 1
      p each[1]
      if count == 3
        post_title = params[:title]
        post_content = params[:content]
        post_user = User.find(session[:user_id])
        post_tags = params[:tags]
        @usrPost = Post.new(title: post_title, content: post_content, user_name: post_user.user_name, tags: post_tags)
        @usrPost.save
        redirect '/'
      end
    end
  end
  if count < 3
    redirect 'createpost'
  end
end
