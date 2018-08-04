class RecipesController  < ApplicationController

#create and show recipes
  get '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])

      @success_delete = session[:success_delete]
      session[:success_delete] = nil

      erb :'recipes/all_recipes'
    else
      redirect '/login'
    end
  end

  get '/recipes/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by(params[:id])

      @ingredients = Ingredient.all.order([:name])
      @recipe_ingredients = RecipeIngredient.all.order([:name])

      @recipe_failure = session[:recipe_failure]
      session[:recipe_failure] = nil

      erb :'recipes/new_recipe', default_layout
    else
      redirect '/login'
    end
  end


  post '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !recipe_fields_empty?
        @recipe = Recipe.create(name: params[:recipe][:name], content: params[:recipe][:content], directions: params[:recipe][:directions])

        @recipe_ingredient = RecipeIngredient.create(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])

        @ingredient = Ingredient.create(name: params[:ingredient][:name])

        @recipe.recipe_ingredients << @recipe_ingredient
        @ingredient.recipe_ingredients << @recipe_ingredient
        @user.recipes << @recipe

        session[:success_create] = "Successfully added!"
        redirect "/recipes/#{@recipe.id}"
      else
        session[:recipe_failure] = "Recipe not saved. Fill in all fields."
        redirect "/recipes/new"
      end
    else
      redirect 'login'
    end
  end

  #recipe error messages
    get '/recipes/failure' do
      if logged_in?
        @user = User.find(session[:user_id])
        erb :'recipes/failure_recipe'
      else
        redirect '/login'
      end
    end

  get '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      if !@recipe.nil? && current_recipe?
        @recipe_name = @recipe.name.titleize
        @recipe_content = @recipe.content.capitalize
        @recipe_directions = @recipe.directions.capitalize
        @username = @user.username

        @success_create = session[:success_create]
        session[:success_create] = nil

        @success_update = session[:success_update]
        session[:success_update] = nil
        erb :'/recipes/show_recipe', default_layout
      else
        redirect '/recipes'
      end
    else
      redirect '/login'
    end
  end

  get '/recipes/:id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_name = @recipe.name.titleize

      @recipe.recipe_ingredients.each do |i|
        @recipe_quantity = "#{i.quantity}"
      end

      @recipe.ingredients.each do |i|
        @recipe_ingred = "#{i.name.titleize}"
      end
      erb :'/recipes/edit_recipe', default_layout
    else
      redirect '/login'
    end
  end


  patch '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      if !params[:recipe][:name].empty?
        @recipe.update(name: params[:recipe][:name])
      end
      if !params[:recipe][:content].empty?
        @recipe.update(content: params[:recipe][:content])
      end
      if !params[:recipe][:directions].empty?
        @recipe.update(directions: params[:recipe][:directions])
      end

      session[:success_update] = "Successfully updated!"

      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end


  get '/recipes/:id/delete' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      redirect "/home"
    else
      redirect '/login'
    end
  end


  delete '/recipes/:id/delete' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      if @recipe.user_id == current_user.id
        @recipe.delete
      end

      session[:success_delete] = "Successfully deleted!"
      redirect "/recipes"
    else
      redirect "/login"
    end
  end


  # * * * * work in progress * * * * *

  #community recipes
  get '/community/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      @users = User.all
      @recipes = Recipe.all.order([:name])
      @recipe_ingredients = RecipeIngredient.all.order([:name])

      erb :'/community/all_recipes', default_layout
    else
      redirect '/login'
    end
  end

  get '/community/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id])

    @recipe_name = @recipe.name.titleize
    @recipe_content = @recipe.content.capitalize
    @recipe_directions = @recipe.directions.capitalize

    if logged_in?
      @user = User.find(session[:user_id])
      @users = User.all
      @recipes = Recipe.all
      erb :'/community/show_recipe', default_layout
    else
      redirect '/login'
    end
  end

  get '/community/ingredients' do
    if logged_in?
      @user = User.find(session[:user_id])
      @users = User.all
      @recipes = Recipe.all
      @recipe_ingredients = RecipeIngredient.all.order([:name])

      erb :'/community/all_ingredients', default_layout
    else
      redirect '/login'
    end
  end

  get '/community/ingredients/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @users = User.all
      @recipes = Recipe.all
      @recipe_ingredients = RecipeIngredient.all.order(:name)

      erb :'/community/show_ingredient', default_layout
    else
      redirect '/login'
    end
  end

end
