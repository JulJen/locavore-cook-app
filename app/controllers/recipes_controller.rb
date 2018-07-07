class RecipesController  < ApplicationController

#recipe error essages

# user has_many :recipes
# recipe h.m. recipe_ingredients
# recipe hm ingredients, through RI
# ingredient hm recipe ingredients
# ingredient hm recipes through RI


  get '/recipes/failure' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'recipes/failure_recipe'
    else
      redirect '/login'
    end
  end

#create and show recipes
  get '/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by(params[:id])

      @ingredients = Ingredient.all
      @recipe_ingredients = RecipeIngredient.all

      erb :'recipes/new_recipe', default_layout
    else
      redirect '/login'
    end
  end


  get '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'recipes/all_recipes'
    else
      redirect '/login'
    end
  end


  post '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !params[:recipe][:name].empty? && !params[:recipe][:content].empty?
        @recipe = Recipe.create(name: params[:recipe][:name], content: params[:recipe][:content])
      end
      if !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @ingredient = Ingredient.create(name: params[:ingredient][:name])
        @recipe_ingredient = RecipeIngredient.create(name: params[:ingredient][:name], quantity: params[:recipe_ingredient][:quantity])
      end
      @recipe.recipe_ingredients << @recipe_ingredient
      @ingredient.recipe_ingredients << @recipe_ingredient
      @user.recipes << @recipe
      # @recipe.save
      redirect "/recipes/#{@recipe.id}"
      else
        redirect 'login'
      end
    end

  get '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @recipe_name = @recipe.name.titleize

      @recipe.recipe_ingredients.each do |i|
        @recipe_ingred = i.name
        @recipe_quantity = i.quantity
      end
      # @recipe.ingredients.each do |i|
      # @recipe_ingred = i.name
      # end
      #
      # @recipe.recipe_ingredients.each do |i|
      # @recipe_quantity = i.quantity
      # end
      erb :'/recipes/show_recipe', default_layout
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
      @ingredient = Ingredient.find_by_id(params[:id])

      if !params[:recipe][:name].empty?
        @recipe.update(name: params[:recipe][:name])
      elsif !params[:recipe][:content].empty?
        @recipe.update(content: params[:recipe][:content])
      end
      @recipe.save
      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end
    #   if !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
    #     @ingredient = Ingredient.create(name: params[:ingredient][:name])
    #
    #     @recipe_ingredient = RecipeIngredient.create(quantity: params[:recipe_ingredient][:quantity])
    #   end
    #     @ingredient.recipe_ingredients << @recipe_ingredient
    #
    #     # @recipe.ingredients << @ingredient
    #
    #     @recipe.recipe_ingredients << @recipe_ingredient
    #
    #     @recipe.save
    #     redirect "/recipes/#{@recipe.id}"
    #   else
    #     redirect '/login'
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
      if @recipe.user_id == current_user.id
        @recipe.delete
        redirect "/recipes"
      end
    else
      redirect "/login"
    end
  end

end
