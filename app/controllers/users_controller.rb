class UsersController < ApplicationController

#user error essages
  get '/user_failure' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'users/user_failure'
    end
  end

  get '/signup_failure' do
    erb :'users/signup_failure'
  end

  get '/login_error' do
    erb :'users/login_error'
  end

#returning user log-in
  get '/login' do
    erb :'users/login'
  end
  #   if logged_in?
  #     redirect '/show'
  #   else
  #     erb :'users/login'
  #   end
  # end

  post '/login' do
    # if user && user.authenticate(params[:password])
    # if user_passfail
    #   session[:user_id] = user.id
    #   redirect '/show'
    # end
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/show_user'
    elsif
      user_fields_empty?
      redirect '/login_error'
    else
      redirect '/login_error'
    end
  end

#new user sign-up
  get '/signup' do
    session.clear
    if logged_in?
      redirect '/show_user'
    elsif !logged_in?
      erb :'/signup'
    end
  end

  post '/signup' do
    if logged_in?
      redirect '/show_user'
    elsif !user_fields_empty?
      # @user = User.create(:username => params[:username], :password => params[:password])
      # @user.save
      # session[:user_id] = @user.id
      # create_new_user

      @user = User.create(:name => params[:name], :email => params[:email], :username => params[:username], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect '/more_info'
    else
      redirect '/signup_failure'
    end
  end

  get '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'/more_info'
    else
      redirect '/login_failure'
    end
  end

  post '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !user_more_info_empty?
        @user.update(state: params[:state], content: params[:content])
        @user.save
        redirect '/show_user'
      else
        redirect '/more_info'
      end
    else
      redirect '/login_failure'
    end
  end


#user account info
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/show_user'
    # redirect '/show'
  end

  get '/show_user' do
    if logged_in?
      @user = User.find(session[:user_id])
      # @recipe = Recipe.find_by_id(params[:id])
      @recipes = Recipe.all
      erb :'users/show_user'
    else
      redirect '/login'
    end
  end

  get '/edit_account' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'/users/edit_account'
    elsif redirect '/login'
    else
      redirect '/login'
    end
  end

  patch '/show_user' do
    if logged_in?
      @user = User.find(session[:user_id])
      if user_more_info_empty?
        redirect '/user_failure'
      elsif !params[:state].empty?
        @user.update(state: params[:state])
      elsif !params[:content].empty?
        @user.update(content: params[:content])
      end
      @user.save
      redirect '/show_user'
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
