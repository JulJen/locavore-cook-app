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

      def current_user
        User.find_by_id(session[:user_id])
      end

      # def create_new_user
      #   true if !user_fields_empty?
      #   @user = User.create(:name => params[:name], :email => params[:email], :username => params[:username], :password => params[:password])
      #   @user.save
      #   session[:user_id] = @user.id
      # rescue false
      # end
      # end

      def user_passfail
        true if User.find_by(:username => params[:username]) && user.authenticate(params[:password]) rescue false
      end

      def user_fields_empty?
        true if params[:name] == "" || params[:username] == "" || params[:email] == "" || params[:password] == "" rescue false
      end
    end

  end
