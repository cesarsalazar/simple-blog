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
  haml :home
end

['/observations', '/observaciones'].each do |path|
  get path do
    @index = RDiscount.new( File.open("contents/index.md").read ).to_html
    haml :index
  end
end

['/observations/:article', '/observaciones/:article'].each do |path|
  get path do
    @content = RDiscount.new( File.open("contents/" + params["article"].gsub("-", "_").concat(".md")).read ).to_html
    @doc_title = Nokogiri::HTML::DocumentFragment.parse( @content ).css('h1').inner_html()  
    @title = "#{@doc_title} by @cesarsalazar"
    haml :single
  end
end

get '/merida' do
  haml :merida
end

# Redirects

get '/:url_to_redirect' do
  status 301
  urls = { "df"               => "http://cesarsalazar.pbworks.com/w/page/24857335/DF",
           "bio"              => "http://cesarsalazar.pbworks.com/w/page/52608776/Bio",
           "cv"               => "http://cesarsalazar.pbworks.com/w/page/10755048/CV%20Espa%C3%B1ol",
           "bancos"           => "http://cesarsalazar.pbworks.com/w/page/10755043/bancos",
           "oficina"          => "http://g.co/maps/4ergp",
           "magmarails"       => "https://speakerdeck.com/u/cesarsalazar/p/startuprb",
           "pitch"            => "https://speakerdeck.com/u/cesarsalazar/p/pitch",
           "neighborhood"  => "http://goo.gl/maps/EzQuI" }
  urls.each do |url, location|
    redirect location if url == params[:url_to_redirect]
  end
  redirect '/'
end

get '/stylesheets/*' do
  content_type 'text/css'
  sass '../styles/'.concat(params[:splat].join.chomp('.css')).to_sym
end