class IngredientsController < ApplicationController

  get '/recipes/:id/edit/all' do
      if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_name = @recipe.name.titleize

      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])

      erb :'/ingredients/show_recipe_ingredients', default_layout
    else
      redirect '/login'
    end
  end

  get '/ingredients/:id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by(params[:id])
      # @recipe = Recipe.find_by_id(params[:id])

      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])

      @recipe.recipe_ingredients.each do |i|
        @ingredient_name = i.name
        @ingredient_quantity = i.quantity
        @ingredient_id = i.id
      end
      # @ingredient_name = @recipe_ingredient.name.titleize
      # @ingredient_quantity = @recipe_ingredient.quantity
      erb :'/ingredients/edit_ingredient', default_layout
    else
      redirect '/login'
    end
  end

  patch '/ingredients/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by(params[:id])
      # @recipe = Recipe.find_by_id(params[:id])

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
      redirect "/recipes/#{@recipe.id}/edit/all"
    else
      redirect '/login'
    end
  end


  get '/recipes/:id/add' do # see recipe_controller for post '/recipes/:id'
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      erb :'/ingredients/new_ingredient', default_layout
    else
      redirect '/login'
    end
  end


  post '/recipes/:id' do # see ingredients_controller for get '/recipes/:id/add'
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      if !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?

        @ingredient = Ingredient.create(name: params[:ingredient][:name])
        @recipe_ingredient = RecipeIngredient.create(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])
        @recipe.recipe_ingredients << @recipe_ingredient
        @ingredient.recipe_ingredients << @recipe_ingredient
        # @recipe.save
        redirect "/recipes/#{@recipe.id}"
      else
        redirect '/recipes/:id/add'
      end
    else
      redirect '/login'
    end
  end


  delete '/ingredients/:id/delete' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])

      @recipe.recipe_ingredients.each do |i|
        @recipe_ingredient_name = i.name
        @recipe_ingredient_id = i.ingredient_id
      end

      @recipe.ingredients.each do |i|
        @ingredient_name = i.name
        @ingredient_id = i.id
      end

      if @ingredient_id == @recipe_ingredient_id
        @recipe.recipe_ingredients.map do |i|
          if @ingredient.id == i.ingredient_id
            i.delete
          end
        end
        @recipe.save
      end

      redirect "/recipes/#{@recipe.id}/edit/all"
    else
      redirect "/login"
    end
  end

end
