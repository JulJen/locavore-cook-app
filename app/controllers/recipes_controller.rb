class RecipesController  < ApplicationController

#show recipes
  get '/show_recipe' do
    if logged_in?
      erb :'/recipes/show_recipe'
    else
      redirect '/login'
    end
  end

  get '/all_recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      # @recipe = Recipe.find_by_id(params[:id])
      @recipes = Recipe.all
      @ingredients = Ingredient.all
      erb :'/recipes/all_recipes'
    else
      redirect '/login'
    end
  end

#create new recipe

  get '/new_recipe' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'/recipes/new_recipe'
    else
      redirect '/login'
    end
  end

  get '/recipe' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      erb :'recipes/new_recipe'
    else
      redirect '/login'
    end
  end

  post '/recipe' do
    #  if !params[:content].empty?
    # @recipe = Recipe.new(
    #   name:   params[:name],
    #   user_id: current_user.id
    # )
    # if @recipe.save
    #   redirect '/recipes/#{@recipe.id}'
    if !params[:recipe][:name].empty?
      @recipe = Recipe.create(name: params[:name], user_id: current_user.id)
      @ingredient = Ingredient.create(name: params[:name], user_id: current_user.id)
      redirect "/recipes/#{@recipe.id}"
    else
      erb :'/recipes/new_recipe'
    end
  end

  #   #Add new recipe names
  #   if !params[:recipe][:name].empty? || !params[:ingredient][:content].empty?
  #     @recipe = Recipe.create(name: params[:name], content: params[:content], user_id: current_user.id)
  #     @recipe.save
  #     # erb :'recipes/show'
  #     # redirect to '/recipes'
  #     redirect to "/recipes/#{@recipe.id}"
  #     # @recipe = Recipe.create(:name => params[:name])
  #     # @recipe.save
  #   # elsif
  #     # user_recipe_empty?
  #     # redirect to '/failure'
  #   else
  #     redirect to '/create'
  #   end
  # end
  #   # if !params[:ingredient][:name].empty?
  #   #   @recipe.ingredients << Recingredient.create(params[:ingredient])
  #   # else
  #   #   redirect to '/recipes/new'
  #   # end

  get '/recipes/:id' do
    if logged_in?
      # @user = User.find(session[:user_id])
      # @recipe = @user.recipes.find_by_id(params[:id])
      @recipe = Recipe.find_by_id(params[:id])
      erb :'recipes/show_recipes'
      # erb :'recipes/show_recipe'
      # erb :'recipes/new_recipe'
    else
      redirect '/login'
    end
  end

#update recipe
  get '/recipes/:id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      # @ingredients = Ingredient.all
      erb :'/recipes/edit'
    else
      redirect '/login'
    end
  end

  patch '/recipes/:id' do
    if logged_in?
      @recipe= Recipe.find_by_id(params[:id])
      @ingredient= Ingredient.find_by_id(params[:id])
      if !params[:recipe][:name].empty?
        @recipe.update(name: params[:recipe][:name])
      elsif !params[:ingredient][:name].empty?
        # @figure.landmarks << Landmark.create(params[:landmark])
        @recipe.ingredients << Ingredient.create(params[:ingredient])
        # @recipe.ingredient.update(name: params[:ingredient][:name])
      end
      @recipe.save
      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end

  delete '/recipes/:id/delete' do
    if logged_in?
      @recipe.name = Recipe.find_by_id(params[:id])
      if @recipe && current_user.id == @recipe.user_id
        @recipe.delete
        redirect '/all_recipes'
      end
    elsif !logged_in?
      redirect "/login"
    else
      redirect "/recipe/#{@recipe.id}"
    end
  end

  # helpers do
  #   def user_recipe_empty?
  #     true if params[:recipe][:name] == "" && params[:ingredient][:content] == "" rescue false
  #   end
  # end

end
