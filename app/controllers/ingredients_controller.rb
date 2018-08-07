class IngredientsController < ApplicationController

  get '/recipes/:id/ingredients' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      if @recipe && !@recipe.nil? && @recipe.user_id == @user.id
        @recipe_name = @recipe.name.titleize

        @recipe.recipe_ingredients. each do |i|
          @ingredient_id = i.id
        end

        @success_create = session[:success_create]
        session[:success_create] = nil

        @success_update = session[:success_update]
        session[:success_update] = nil

        erb :'ingredients/show_recipe_ingredients', default_layout
      else
        redirect "/recipes"
      end
    else
      redirect '/login'
    end
  end

  get '/recipes/:id/ingredients/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      if @recipe && !@recipe.nil? && @recipe.user_id == @user.id

        @recipe_failure = session[:failure]
        session[:failure] = nil

        erb :'ingredients/new_ingredient', default_layout
      else
        redirect "/recipes"
      end
    else
      redirect '/login'
    end
  end

  post '/recipes/:id/ingredients' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:recipe_ingredient_id])

      if !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @ingredient = Ingredient.create(name: params[:ingredient][:name])
        @recipe_ingredient = RecipeIngredient.create(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])

        @recipe.recipe_ingredients << @recipe_ingredient
        @ingredient.recipe_ingredients << @recipe_ingredient

        session[:success_create] = success_create
        redirect "/recipes/#{@recipe.id}/ingredients"
      else
        session[:failure] = incomplete_message
        redirect "/recipes/#{@recipe.id}/ingredients/new"
      end
    else
      redirect '/login'
    end
  end


  get '/recipes/:id/ingredients/:recipe_ingredient_id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:recipe_ingredient_id])

      if @recipe &&!@recipe.nil? && @recipe.user_id == @user.id && @recipe_ingredient && @recipe_ingredient.recipe && @recipe_ingredient.recipe.user_id == @user.id

        @recipe_failure = session[:failure]
        session[:failure] = nil

        erb :'ingredients/edit_ingredient', default_layout
      else
        redirect "/recipes"
      end
    else
      redirect '/login'
    end
  end


  patch '/recipes/:id/ingredients/:recipe_ingredient_id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:recipe_ingredient_id])

      @ingredient = Ingredient.find_by_id(params[:id])

      if !params[:ingredient][:name].empty? && params[:recipe_ingredient][:quantity].empty?
        @recipe_ingredient.update(name: params[:ingredient][:name])
        # @ingredient.update(name: params[:ingredient][:name])
      elsif !params[:recipe_ingredient][:quantity].empty? && params[:ingredient][:name].empty?
        @recipe_ingredient.update(quantity: params[:recipe_ingredient][:quantity])
      elsif !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @recipe_ingredient.update(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])
        # @ingredient.update(name: params[:ingredient][:name])
      else
        session[:failure] = no_input
        redirect "/recipes/#{@recipe.id}/ingredients/#{@recipe_ingredient.id}/edit"
      end

      if @recipe_ingredient.save
        session[:success_update] = success_update
        redirect "/recipes/#{@recipe_ingredient.recipe_id}/ingredients"
      end
    else
      redirect '/login'
    end
  end

  delete '/ingredients/:id/delete' do
    if logged_in?
      @user = User.find(session[:user_id])
      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])

      if !@recipe_ingredient.blank?
        @recipe_ingredient.delete
      end
      session[:success_update] = "Successfully updated!"
      redirect "/recipes/#{@recipe_ingredient.recipe_id}"
    else
      redirect '/login'
    end
  end

end
