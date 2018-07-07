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

    @user = User.find_by(:username => params[:username])
    if !log_in_empty?
      if @user == User.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/show'
      end
    elsif !log_in_empty? && @current_user == nil
        redirect '/failure'
    else
      redirect '/incomplete'
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
    elsif !logged_in? && !user_fields_empty?
      @user = User.create(:fname => params[:fname], :lname => params[:lname], :email => params[:email], :username => params[:username], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect '/more_info'
    elsif !logged_in? && user_fields_empty?
      redirect '/incomplete'
    else
      redirect '/signup'
    end
  end

  get '/more_info' do

    @user = User.find(session[:user_id])
    if current_user && logged_in?
      erb :'users/more_info'
    else
      redirect '/login'
    end
  end

  post '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !more_info_empty?
        @user.update(state: params[:state], bio: params[:bio])
      elsif !params[:state].empty?
        @user.update(state: params[:state])
      elsif !params[:bio].empty?
        @user.update(bio: params[:bio])
      end
      @user.save
      redirect '/show'
    else
      redirect '/failure'
    end
  end

#user account info
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @user = User.find(session[:user_id])
    @recipe = Recipe.find_by_id(params[:id])
    erb :'users/show_user', default_layout
  end

  get '/show' do
    if logged_in?
      redirect '/users/:slug'
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
      if !more_info_empty?
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
      @current_user = nil
      session.clear
      redirect '/'
    else
      redirect '/failure'
    end
  end

end
