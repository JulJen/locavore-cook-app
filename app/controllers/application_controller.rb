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
    redirect '/main'
  end

  get '/main' do
    session.clear
    erb :'application/root', default_layout
  end
    # , :layout => :layout
    # , locals: {now: Time.now}
  # end


  helpers do
#layouts
    def default_layout
      # if request.path.start_with?('/failure')
      if request.path_info.start_with?('/main', '/signup', '/login')
        {:layout => :'/layouts/signin'}
      elsif request.path_info.start_with?('/failure', '/incomplete')
        {:layout => :'/layouts/error'}
      elsif request.path_info.start_with?('/recipe', '/recipes')
        {:layout => :'/layouts/recipe'}
      else
        {:layout => :'layouts/user'}
      end
    end

#layouts  - default messages in layout
    def welcome_message
      message = "Welcome to Locavore Kitchen!"
    end

    def return_message
      message = "Welcome back to Locavore Kitchen!"
    end

    def default_message
      message = "Locavore Kitchen App"
    end

    def error_message
      message = "Oops, Error!"
    end

    def incomplete_message
      message = "Incorrect username and password!"
    end

    def name
      if logged_in?
        @user = User.find(session[:user_id])
        name = @user.username
      end
    end


#users_controller  and recipes_controller
    def logged_in?
      session[:user_id]
      # !!session[:user_id]
    end

    def current_user
      # when we log out, we would want to execute:
      # @current_user = nil
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_recipe
      @current_recipe ||= Recipe.find_by(params[:id]) if Recipe.last
    end

    def current_ingred
      @current_ingred ||= Ingredient.find_by(params[:id]) if Ingredient.last
    end

#users_controller
    def user_passfail?
      true if User.find_by(:username => params[:username]) && user.authenticate(params[:password_digest]) rescue false
    end

    def user_fields_empty?
      true if params[:fname] == "" || params[:lname] == "" || params[:username] == "" || params[:email] == "" || params[:password] == "" rescue false
    end

    def user_more_info_empty?
      true if params[:state] == "" || params[:bio] == "" rescue false
    end

#RecipesController
    def recipe_fields_empty?
      true if params[:recipe][:name].empty? && params[:recipe][:content].empty? && params[:ingredient][:name].empty? && params[:recipe_ingredient][:quantity].empty?  rescue false
    end

    def recipe_pass?
      true if @recipe && current_user.id == @recipe.user_id rescue false
    end

  end
end
