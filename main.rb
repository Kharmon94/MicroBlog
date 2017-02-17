require "sinatra"
require "active_record"
require "sinatra/activerecord"
require "sqlite3"
require "sinatra/flash"
require "./models"

set :database, "sqlite3:practice.db"
enable :sessions

before do
  current_user
end
# have get '/sign-up' do
# have then enter in 4 things f,lname and user, password.
# it will use user.create and then read the values from the form just like how a post is created.
# post /sign-up
# verify username is unique. once unique can store their data with password provided. validates_uniqueness_of :username
# get'/dashboard' to show them

get '/' do
  @user = User.all
  p @current_user
  erb :index
end

get '/signup' do
  erb :signup
end

post '/sign-up' do
  @user = User.create(
  fname: params[:first_name],
  lname: params[:last_name],
  username: params[:username],
  password: params[:password]
  )
  session[:user_id] = @user.id
  redirect '/posts'
end


get '/logout' do
  session.destroy
  redirect '/'
end

get '/login-failed' do
  erb :fail
end

post '/posts/new' do
  @post = Post.create(params[:post])
  redirect '/posts'
end

get '/posts' do
  @posts = Post.all
  erb :posts
end

get '/post/:id' do
  @post = Post.find(params[:id])
  erb :post
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
    flash[:notice] = "Login Failed."
  end
  redirect '/'
end


def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end
