class RecipesController  < ApplicationController

#recipe error essages
  get '/failure' do
    if logged_in?
      @user = User.find(session[:user_id])
    else
      erb :'recipes/failure', default_layout
    end
  end

  get '/signup_failure' do
    erb :'users/signup_failure'
  end

#create and show recipes
  get '/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'recipes/new_recipe', default_layout
    else
      redirect '/login'
    end
  end

  get '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      # @recipe = Recipe.find_by_id(params[:id])
      # @ingredient = Ingredient.find_by_id(params[:id])
      erb :'recipes/all_recipes'
    else
      redirect '/login'
    end
  end

  post '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !recipe_fields_empty?
        @recipe = Recipe.create(name: params[:recipe][:name], user_id: current_user.id)
        @ingredient = Ingredient.create(name: params[:ingredient][:name], user_id: current_user.id, recipe_id: current_recipe.id)
        redirect "/recipes/#{@recipe.id}"
      else
        redirect '/new'
      end
    else
      redirect '/failure'
    end
  end

  get '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])
      erb :'/recipes/show_recipe', default_layout
    else
      redirect '/login'
    end
  end

#update recipe
  get '/recipes/:id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @ingredients = Ingredient.all
      @ingredient = Ingredient.find_by_id(params[:id])
      erb :'/recipes/edit', default_layout
    else
      redirect '/login'
    end
  end

  # if !recipe_fields_empty?
  #   @recipe.update(name: params[:recipe][:name])
  #   @ingredient = Ingredient.update(name: params[:ingredient][:name])
  # elsif !params[:recipe][:name].empty?
  #   @user.update(name: params[:recipe][:name])
  # elsif !params[:ingredient][:name].empty?
  #   @user.update(name: params[:ingredient][:name])
  # end


  patch '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe= Recipe.find_by_id(params[:id])
      @ingredient= Ingredient.find_by_id(params[:id])

      if !params[:recipe][:name].empty?
        @recipe.update(name: params[:recipe][:name])
      elsif !params[:ingredient][:name].empty?
        @ingredient = Ingredient.update(name: params[:ingredient][:name])
      # end

      # if !recipe_fields_empty?
      #   @recipe.update(name: params[:recipe][:name])
      #   @ingredient = Ingredient.update(name: params[:ingredient][:name])

      # if !params[:recipe][:name].empty?
        # @recipe.update(name: params[:recipe][:name])
      # elsif !params[:ingredient][:name].empty?
      else
        @ingredient = Ingredient.create(name: params[:ingredient][:name], user_id: current_user.id)
      end
      @recipe.save
binding.pry

      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end

  # post '/recipes/:id' do
  #   if logged_in?
  #     @user = User.find(session[:user_id])
  #     # if !params[:recipe][:name].empty? && !params[:ingredient][:name].empty?
  #     if !params[:ingredient][:name].empty?
  #       # @recipe.ingredients << Ingredient.create(params[:ingredient])
  #       @ingredient = Ingredient.create(params[:ingredient][:name], user_id: current_user.id)
  #       @recipe.save
  #       redirect "/recipes/#{@recipe.id}"
  #     else
  #       redirect '/new'
  #     end
  #   else
  #     redirect '/failure'
  #   end
  # end

  get '/recipes/:id/delete' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      redirect "/show"
    else
      redirect '/login'
    end
  end

  delete '/recipes/:id/delete' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      if current_user.id == @recipe.user_id
      # if recipe_pass?
        @recipe.delete
        redirect "/recipes"
      else
        redirect "/recipe/#{@recipe.id}"
      end
    else
      redirect "/login"
    end
  end

end
