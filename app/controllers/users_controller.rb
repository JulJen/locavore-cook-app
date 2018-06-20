class UsersController < ApplicationController

#user error essages
  get '/failure' do
    erb :'users/failure'
  end

  get '/login_error' do
    erb :'users/login_error'
  end

#new user sign-up
  get '/signup' do
    if logged_in?
      redirect '/show'
    elsif !logged_in?
      erb :'users/signup'
    end
  end

  post '/signup' do
    if logged_in?
      redirect '/show'
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
      redirect '/failure'
    end
  end

  get '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'users/more_info'
    end
  end

  post '/more_info' do
    if logged_in?
      @user = User.find(session[:user_id])
    end
  end

#returning user log-in
  get '/login' do
    if logged_in?
      redirect '/show'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    # user = User.find_by(:username => params[:username])
    # if user && user.authenticate(params[:password])
    if user_passfail
      session[:user_id] = user.id
      redirect '/show'
    elsif
      user_fields_empty?
      redirect 'login_error'
    else
      redirect '/login'
    end
  end

#user account info
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
    # redirect '/show'
  end

  get '/show' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'/users/show'
    else
      redirect '/login'
    end
  end

  get '/edit_account' do
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
      # @user.update(state: params[:state], content: params[:content])
      if !params[:state].empty?
        @user.update(state: params[:state])
      elsif !params[:content].empty?
        @user.update(content: params[:content])
      end
      @user.save
      redirect '/show'
      # end
      # else
        # redirect "/user/edit_account"
      # end
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

  # patch '/landmarks/:id' do
  #   @landmark = Landmark.find_by_id(params[:id])
  #   # @landmark.update(params[:landmark])
  #   @landmark.update(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed])
  #
  #   @landmark.save
  #   redirect "/landmarks/#{@landmark.id}"
  # end
end
