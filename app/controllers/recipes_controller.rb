class RecipesController  < ApplicationController

#create and show recipes
  get '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
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

      erb :'recipes/new_recipe', default_layout
    else
      redirect '/login'
    end
  end


  post '/recipes' do
binding.pry
    if logged_in?
      @user = User.find(session[:user_id])
      if !recipe_fields_empty?
        @recipe = Recipe.create(name: params[:recipe][:name], content: params[:recipe][:content], directions: params[:recipe][:directions])

        @recipe_ingredient = RecipeIngredient.create(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])

        @ingredient = Ingredient.create(name: params[:ingredient][:name])

        @recipe.recipe_ingredients << @recipe_ingredient
        @ingredient.recipe_ingredients << @recipe_ingredient
        @user.recipes << @recipe

        redirect "/recipes/#{@recipe.id}"
      else
        redirect '/recipes/failure'
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

      if @recipe.user_id == @user.id

        @recipe_name = @recipe.name.titleize

        @recipe.recipe_ingredients.each do |i|
          @recipe_ingred = i.name
          @recipe_quantity = i.quantity
        end

        def recipe_time
          @recipe.each do |i|
            @recipe_time = i.created_at
          end
        end

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

      session[:success_message] = "Successfully created recipe."

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
      redirect "/recipes"
    else
      redirect "/login"
    end
  end


  # * * * * work in progress * * * * *

  #community recipes
  get '/community/locavore_recipes' do
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

  get '/community/locavore_recipes/:user_id/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @users = User.all
      @recipes = Recipe.all
      erb :'/community/show_recipe', default_layout
    else
      redirect '/login'
    end
  end

  get '/community/locavore_ingredients' do
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

  get '/community/locavore_ingredients/:id' do
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
