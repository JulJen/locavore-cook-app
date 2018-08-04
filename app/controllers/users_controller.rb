class UsersController < ApplicationController

#new user sign-up
  get '/signup' do
    if logged_in?
      redirect '/home'
    else
      erb :'users/signup', default_layout
    end
  end

  post '/signup' do
    if !logged_in? && !user_fields_empty?
      @user = User.new(params)
      # @user = User.new(:fname => params[:fname], :lname => params[:lname], :email => params[:email], :username => params[:username], :password => params[:password], state: params[:state], bio: params[:bio])
      if @user.valid?
        @user.save
        session[:user_id] = @user.id
        redirect '/more_info'
      end
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
    @user = User.find(session[:user_id])
    if !logged_in?
      if !more_info_empty?
        @user.update(state: params[:state], bio: params[:bio])
      elsif !params[:state].empty?
        @user.update(state: params[:state])
      elsif !params[:bio].empty?
        @user.update(bio: params[:bio])
      redirect '/home'
      end
    else
      redirect '/login'
    end
  end

#user account info
  get '/home' do
    # @user = User.find_by_slug(params[:slug])
    @user = User.find_by_id(session[:user_id])
    @recipe = Recipe.find_by_id(params[:id])

    @recipes = Recipe.all
    erb :'users/show_user', default_layout
  end

  get '/account' do
    if logged_in?
      @user = User.find(session[:user_id])

      @success_account = session[:success_account]
      session[:success_account] = nil

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

  patch '/account' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !more_info_empty?
        if !params[:state].empty?
          @user.update(state: params[:state])
        end
        if !params[:bio].empty?
        @user.update(bio: params[:bio])
        end

        session[:success_account] = "Successfully updated account!"
        redirect '/account'
      else
        redirect '/edit'
      end
    else
      redirect '/login'
    end
  end

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

end
