class UsersController < ApplicationController

#user error essages
#incomplete
  get '/incomplete' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
    erb :'users/user_failure', default_layout
  end

# incorrect
  get '/failure' do
    erb :'users/login_failure', default_layout
  end

# not logged in
  get '/error' do
    erb :'users/login_error', default_layout
  end

#returning user log-in
  get '/login' do
    if logged_in?
      redirect '/show'
    else
      erb :'users/login', default_layout
    end
  end

  post '/login' do
    # if user && user.authenticate(params[:password])
    # if user_passfail?
    #   session[:user_id] = user.id
    #   redirect '/show'
    # end
    # user = User.find_by(:username => params[:username])
    # if user && user.authenticate(params[:password])
    if user_passfail?
      session[:user_id] = user.id
      redirect '/show'
    elsif
      user_fields_empty?
      redirect '/failure'
    elsif !user_passfail?
      redirect '/failure'
    end
  end

#new user sign-up
  get '/signup' do
    if logged_in?
      redirect '/show'
    else
      erb :'users/signup', default_layout
    end
  end

  post '/signup' do
    if logged_in?
      redirect '/show'
    elsif !user_fields_empty?
      @user = User.create(:fname => params[:fname], :lname => params[:lname], :email => params[:email], :username => params[:username], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect '/more_info'
    elsif user_fields_empty?
      redirect '/incomplete'
    else
      redirect '/signup'
    end
  end

  get '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'users/more_info'
    else
      redirect '/error'
    end
  end

  post '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !user_more_info_empty?
        @user.update(state: params[:state], bio: params[:bio])
      elsif !params[:state].empty?
        @user.update(state: params[:state])
      elsif !params[:bio].empty?
        @user.update(bio: params[:bio])
      end
      @user.save
      redirect '/show'
      # if !user_more_info_empty?
      #   # @user = User.create(:state => params[:state], :bio => params[:bio])
      #   @user.update(state: params[:state], bio: params[:bio])
      #   @user.save
      #   redirect '/show'
    else
      redirect '/failure'
    end
  end

#user account info
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show_user'
  end

  get '/show' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      # @recipes = Recipe.all
      # if @recipe.name == nil
      erb :'users/show_user', default_layout
    else
      redirect '/failure'
    end
  end

  get '/account' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'users/show_account', default_layout
    else
      redirect '/login'
    end
  end

  get '/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'/users/edit_account'
    else
      redirect '/login'
    end
  end

  patch '/show' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !user_more_info_empty?
        @user.update(state: params[:state], bio: params[:bio])
      elsif !params[:state].empty?
        @user.update(state: params[:state])
      elsif !params[:bio].empty?
        @user.update(bio: params[:bio])
      end
      @user.save
      redirect '/account'
    else
      redirect '/login'
    end
  end

#user log-out
  get '/logout' do
    if logged_in?
      session.clear
      redirect '/'
    else
      redirect '/all_recipes'
    end
  end

end
