require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require_relative '../lib/link'
require_relative '../lib/tag'
require_relative '../lib/user'
require_relative './helpers'
require_relative './datamapper'

enable :sessions
use Rack::Flash
use Rack::MethodOverride
set :session_secret, 'super secret'

get '/' do
  @links = Link.all
  erb :index
end

get '/tags/:text' do
  tag = Tag.first(text: params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  @user = User.new
  erb :'users/new'
end

get '/sessions/new' do
  erb :'sessions/new'
end

post '/links' do
  url = params['url']
  title = params['title']
  tags = params['tags'].split(' ').map do |tag|
    Tag.first_or_create(text: tag)
  end
  Link.create(url: url, title: title, tags: tags)
  redirect to('/')
end

post '/users' do
  @user = User.create(email: params[:email],
                      password: params[:password],
                      password_confirmation: params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :'users/new'
  end
end

post '/session' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ['The email or password is incorrect']
    erb :'sessions/new'
  end
end

delete '/session' do
  flash[:notice] = 'Good bye!'
  session[:user_id] = nil
  redirect to('/')
end

helpers Helpers
