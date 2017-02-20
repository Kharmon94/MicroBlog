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
  p @user
    unless @user && @user.id
      flash[:notice] = "Sorry not Sorry"
      redirect '/'
    else
    session[:user_id] = @user.id
  end
  redirect '/'
end
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
get '/logout' do
  session.destroy
  redirect '/'
end


get '/post/:id' do
  @post = Post.find(params[:id])
  erb :post
end
get '/posts' do
  @posts = Post.all
  erb :posts
end
post '/posts/new' do
  @post = Post.create(params[:post])
  redirect '/posts'
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

def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end
