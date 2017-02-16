require "sinatra"
require "active_record"
require "sinatra/activerecord"
require "sqlite3"
require "./models"

set :database, "sqlite3:practice.db"
enable :sessions

before do
  current_user
end

# DO that before do to check for user is logged in

get '/' do
  @user = User.all
  p @current_user
  erb :index
end

# post login will go here here is where we need to check username and password to make it correct
# if else statement will send user to a logged in session

post '/login' do
  @user = User.where(username: params[:user]).first
  if @user && @user.password == params[:password]
    # redirect '/'
    session[:user_id] = @user.id
    flash[:notice] = "Successfully logged in..."
    puts params.inspect
    params.inspect
  else
    redirect '/login-failed'
  end
end

get '/login-failed' do
  erb :fail
end


def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end
