require 'sinatra'
require 'data_mapper'
require_relative '../lib/link'
require_relative '../lib/tag'
require_relative '../lib/user'
require_relative './helpers'
require_relative './datamapper'

enable :sessions
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
  erb :'users/new'
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
  user = User.create(email: params[:email],
                     password: params[:password],
                     password_confirmation: params[:password_confirmation])
  session[:user_id] = user.id
  redirect to('/')
end

helpers Helpers
