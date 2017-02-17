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

get '/logout' do
  session.destroy
  redirect '/'
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
    redirect '/'
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






get "/settings" do
  if session[:user_id]
    erb :settings
  else
    redirect "/"
  end
end



post "/settings" do
  current_user.update(
  fname: params[:fname],
  lname: params[:lname],
  username: params[:username],
  )
  # Update password if current password is correct
  if(current_user.password == params[:password] && params[:new_password].length > 0)
    current_user.update(
    password: params[:new_password]
    )
  end

  redirect back
end

post "/delete-account" do
  current_user.destroy
  session[:user_id] = nil
  redirect "/"
end
