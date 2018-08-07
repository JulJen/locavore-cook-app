class SessionsController  < ApplicationController

#user log-in
  get '/login' do
    if logged_in?
      @user = User.find(session[:user_id])
      redirect '/home'
    else
      @user_failure = session[:user_failure]
      session[:user_failure] = nil

      erb :'sessions/login', default_layout
    end
  end

  post '/login' do
    if !logged_in? && !user_fields_empty?
      @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/home'
      else
        session[:user_failure] = invalid_message
        redirect '/login'
      end
    else 
      session[:user_failure] = incomplete_message
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
