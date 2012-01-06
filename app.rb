# encoding: UTF-8

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'rdiscount'
require 'nokogiri'

before do
  cache_control :public, :must_revalidate, :max_age => 600
end

get '/' do
  haml :index
end

get '/observaciones' do
  @index = RDiscount.new( File.open("contents/index.md").read ).to_html
  haml :articles
end

get '/observaciones/:article' do
  @content = RDiscount.new( File.open("contents/" + params["article"].gsub("-", "_").concat(".md")).read ).to_html
  doc_title = Nokogiri::HTML::DocumentFragment.parse( @content ).css('h1').inner_html()  
  @title = "#{doc_title} | Observaciones de un explorador, por César Salazar"
  haml :article
end

get '/stylesheets/*' do
  content_type 'text/css'
  sass '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym
end