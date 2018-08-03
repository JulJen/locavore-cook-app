class SessionsController  < ApplicationController

#user log-in
  get '/login' do
    if logged_in?
      @user = User.find(session[:user_id])
      redirect '/home'
    else
      erb :'sessions/login', default_layout
    end
  end

  post '/login' do
    if !logged_in? && !user_fields_empty?
      @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/home'
      elsif !current_user
        redirect '/failure'
      end
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
