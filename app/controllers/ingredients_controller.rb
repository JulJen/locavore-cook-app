class IngredientsController < ApplicationController

  get '/recipes/:id/ingredients' do
      if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_name = @recipe.name.titleize

      @recipe.recipe_ingredients. each do |i|
        @ingredient_id = i.id
      end

      erb :'/ingredients/show_recipe_ingredients', default_layout
    else
      redirect '/login'
    end
  end


  get '/ingredients/:id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])

      erb :'/ingredients/edit_ingredient', default_layout
    else
      redirect '/login'
    end
  end


  patch '/ingredients/:id' do
    if logged_in?
      @user = User.find(session[:user_id])

      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])
      if !params[:ingredient][:name].empty? && params[:recipe_ingredient][:quantity].empty?
        @recipe_ingredient.update(name: params[:ingredient][:name])
        @ingredient.update(name: params[:ingredient][:name])
      elsif !params[:recipe_ingredient][:quantity].empty? && params[:ingredient][:name].empty?
        @recipe_ingredient.update(quantity: params[:recipe_ingredient][:quantity])
      elsif !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @recipe_ingredient.update(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])
        @ingredient.update(name: params[:ingredient][:name])
      end
      redirect '/recipes'
    else
      redirect '/login'
    end
  end


  get '/recipes/:id/ingredients/new' do # see recipe_controller for post '/recipes/:id'
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      erb :'/ingredients/new_ingredient', default_layout
    else
      redirect '/login'
    end
  end

  post '/ingredients/:id' do # see ingredients_controller for get '/recipes/:id/add'
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      if !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @ingredient = Ingredient.create(name: params[:ingredient][:name])
        @recipe_ingredient = RecipeIngredient.create(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])
        @recipe.recipe_ingredients << @recipe_ingredient
        @ingredient.recipe_ingredients << @recipe_ingredient
        redirect '/recipes'
      else
        redirect '/recipes/failure'
      end
    else
      redirect '/login'
    end
  end


  delete '/ingredients/:id/delete' do\
    if logged_in?
      @user = User.find(session[:user_id])
      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])

      if !@recipe_ingredient.blank?
        @recipe_ingredient.delete
      end
      redirect '/recipes'
    else
      redirect '/login'
    end
  end

end
