require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  configure :development do
    register Sinatra::Reloader
  end

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "locavore_kitchen_secret"
  end

  get '/' do
    erb :index, locals: {now: Time.now}
  end

  helpers do
  end

end
