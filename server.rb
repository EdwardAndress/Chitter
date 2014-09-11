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

use Rack::Flash

enable :sessions
set :session_secret, 'super secret'

	get '/' do
		@posts = Post.all
		erb :homepage
	end

	delete '/' do
		flash[:notice] = "Goodbye!"
		session[:user_id] = nil
		redirect to '/'
	end

	get '/:user/posts' do
		@posts = Post.all
		erb :user_posts
	end

	post '/:user/posts' do
		@posts = Post.all
		content = params[:message]
		user = User.first(id: session[:user_id])
		tags = params[:tags].split(" ").map do |tag|
				Tag.first_or_create(text: tag)
			end
		Post.create(message: content, tags: tags, user: user.id)
		erb :user_posts
	end

	post '/:user/posts/filter' do
	  	filter_by = Tag.first(:text => params[:filter])
	  	@posts = filter_by ? filter_by.posts : []
	  	erb :user_posts
	end

	get '/user/new' do
		erb :sign_up
	end

	post '/user/new' do 
		@user = User.new(email: params[:email], name: params[:name], password: params[:password], password_confirmation: params[:password_confirmation])
	  	if @user.save
	  		session[:user_id] = @user.id
			redirect to '/:user/posts'
		else
			erb :sign_up
		end
	end

	post '/user/sign_in' do
		email, password = params[:email], params[:password]
		@user = User.authenticate(email, password)
		if @user
			session[:user_id] = @user.id
			redirect to('/:user/posts')
		else
			flash[:errors] = ["The email or password is incorrect"]
			erb :sign_up
		end
	end

	helpers do 
		def current_user
			@current_user ||= User.get(session[:user_id]) if session[:user_id]
		end
	end

  # start the server if ruby file executed directly
  # run! if app_file == $0
