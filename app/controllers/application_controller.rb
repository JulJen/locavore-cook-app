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
    redirect '/main'
  end

  get '/main' do
    session.clear
    erb :'application/root', default_layout
  end


  helpers do

#layouts
    def default_layout
      if request.path_info.start_with?('/main', '/signup', '/login')
        {:layout => :'/layouts/signin'}
      elsif request.path_info.start_with?('/failure', '/incomplete')
        {:layout => :'/layouts/error'}
      elsif request.path_info.start_with?('/recipe', '/recipes')
        {:layout => :'/layouts/recipe'}
      elsif request.path_info.start_with?('/ingredients')
        {:layout => :'/layouts/ingredient'}
      elsif request.path_info.start_with?('/community')
        {:layout => :'/layouts/locavore_recipes'}
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
        @name = @user.username
      end
    end

#users_controller  and recipes_controller
    def logged_in?
      if current_user
        !!session[:user_id]
      end
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_recipe
      @current_recipe ||= Recipe.find_by(params[:id]) if session[:user_id] == current_user.id
    end

    def current_ingred
      @current_ingred ||= Ingredient.find_by(params[:id]) if session[:user_id]
    end

    def titleize(str)
      str.split(/ |\_/).map(&:capitalize).join(" ")
    end

#users_controller
    def user_fields_empty?
      true if params[:fname] == "" || params[:lname] == "" || params[:username] == "" || params[:email] == "" || params[:password] == "" rescue false
    end

    def more_info_empty?
      params[:state] == "" && params[:bio] == ""
    end

    def log_in_empty?
      true if params[:username] == "" &&  params[:password] == "" rescue false
    end

#RecipesController
    def recipe_fields_empty?
      true if params[:recipe][:name] == "" && params[:recipe][:content] == "" && params[:ingredient][:name] == "" && params[:recipe_ingredient][:quantity] == "" rescue false
    end

    def user_recipe
      @user.recipes.each do |recipe|
        @user_recipe = "#{recipe.name.titleize}"
      end
    end

    def sort_column
      params[:sort] ? params[:sort].to_sym : :user_id
    end

  end
end
