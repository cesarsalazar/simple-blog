require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'rdiscount'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/cesarsalazarmx.sqlite3")

class Url
  include DataMapper::Resource
  property :slug,   String,   :key => true
  property :url,    String,   :required => true
end

DataMapper.auto_upgrade!

get '/' do
  haml :index
end

get '/stylesheets/*' do
  content_type 'text/css'
  sass '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym
end

get '/:slug' do
  halt 404 unless url = Url.get(params[:slug])
  redirect url
end