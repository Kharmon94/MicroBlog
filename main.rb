require "sinatra"
require "active_record"
require "sinatra/activerecord"
require "sqlite3"
require "./models"

set :database, "sqlite3:practice.db"

get '/' do
  erb :index
end
