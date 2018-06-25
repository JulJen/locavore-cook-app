class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
  end

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    # set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "locavore_kitchen_secret"
  end

  get '/' do
    erb :'application/root'
    # , locals: {now: Time.now}
  end



  helpers do
    def logged_in?
      !!session[:user_id]
    end

    # def current_user
    #   User.find_by_id(session[:user_id])
    # end

    def current_user
      begin
        @current_user = User.find(session["user_id"].to_i)
      rescue
        @current_user = nil
      end
    end

    def user_passfail
      true if User.find_by(:username => params[:username]) && user.authenticate(params[:password]) rescue false
    end

    def user_fields_empty?
      true if params[:name] == "" || params[:username] == "" || params[:email] == "" || params[:password] == "" rescue false
    end

    # | !params[:email] == "@.com" |

    def user_more_info_empty?
      true if params[:state] == "" && params[:content] == "" rescue false
    end

    # def user_recipe_empty?
    #   true if params[:name] == "" && params[:content] == "" rescue false
    # end
  end

end
