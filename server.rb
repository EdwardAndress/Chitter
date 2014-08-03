require 'sinatra'
require 'data_mapper'
require 'multimap'
require 'rack-flash'
require 'rest-client'
require 'sinatra/partial'

env=ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/chitter_#{env}")

require './lib/post'
require './lib/user'
require './lib/tag'

DataMapper.finalize
DataMapper.auto_upgrade!

  get '/' do
  	@posts = Post.all
    erb :homepage
  end

  get '/:user/posts' do
  	@posts = Post.all
  	erb :user_posts
  end

  post '/:user/posts' do
  	@posts = Post.all
  	content = params[:message]
  	tags = params[:tags].split(" ").map do |tag|
  			Tag.first_or_create(text: tag)
  		end
  	Post.create(message: content, tags: tags)
  	redirect to('/:user/posts')
  end

  post '/:user/posts/filter' do
	  	filter_by = Tag.first(:text => params[:filter])
	  	@posts = filter_by ? filter_by.posts : []
	  	erb :user_posts
  end

  # start the server if ruby file executed directly
  # run! if app_file == $0
