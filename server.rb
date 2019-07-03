require "sinatra"
require "sinatra/activerecord"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: './database.sqlite3')

# set :database, {adapter: "sqlite3", database: "./database.sqlite3"}

enable :sessions

class User < ActiveRecord::Base
end
