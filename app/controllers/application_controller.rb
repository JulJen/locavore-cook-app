require 'sinatra/contrib'

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
    redirect '/welcome'
  end

  get '/welcome' do
    session.clear
    erb :'application/root', default_layout
  end


  helpers do
#users_controller  and recipes_controller
    def authenticate_user
      if !logged_in?
        redirect '/login'
      end
    end

    def logged_in?
      !!session[:user_id]
    end

    def request_params
      @request_params = params.reject { |key, val| val.empty? }.values.join(" , ")
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_username
      @current_username ||= User.find(session[:username]) if session[:username]
    end

    def current_recipe?
      @recipe.user_id == current_user.id if @recipe
    end

    def current_ingredient?
      @recipe_ingredient.recipe.user_id == current_user.id if @recipe_ingredient
    end

    def titleize(str)
      str.split(/ |\_/).map(&:capitalize).join(" ")
    end

#users_controller
    def user_fields_empty?
      params[:fname] == "" || params[:lname] == "" || params[:username] == "" || params[:email] == "" || params[:password] == ""
    end

    def more_info_empty?
      params[:state] == "" || params[:bio] == ""
    end

    def recipe_present?
      true if !@recipe.nil? && !@recipes.nil? rescue false
    end
#RecipesController
    def recipe_fields_empty?
      true if params[:recipe][:name] == "" || params[:recipe][:content] == "" || params[:recipe][:directions] == "" || params[:recipe_ingredient][:name] == "" || params[:recipe_ingredient][:quantity] == "" rescue false
    end

    def sort_column
      params[:sort] ? params[:sort].to_sym : :user_id
    end


#model validation error messages (if !object.valid?)
    def user_error
      @user_error = @user.errors.full_messages.join(", ") if @user.errors
    end

    def user_valid
      !user_error if @user.valid?
    end

#layouts
    def default_layout
      if request.path_info.start_with?('/welcome', '/signup', '/login')
        {:layout => :'/layouts/signin'}
      elsif request.path_info.start_with?('/recipe', '/recipes', '/ingredients')
        {:layout => :'/layouts/recipe'}
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

    def invalid_message
      message = "Incorrect username and password"
    end

    def incomplete_message
      message = "Please complete all fields"
    end

    def no_input
      message = "All fields empty, please fill one in"
    end

    def success_create
      message = "Successfully added!"
    end

    def success_update
      message = "Successfully updated!"
    end

    def success_delete
      message = "Successfully deleted"
    end

  end
end
