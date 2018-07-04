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
      erb :'recipes/new_recipe', default_layout
    else
      redirect '/login'
    end
  end


  get '/recipes' do
binding.pry
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by(params[:id])

      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredients = RecipeIngredient.find_by_id(params[:id])

      # @recipe_user_id = Recipe.find_by(params[:id])
      erb :'recipes/all_recipes'
    else
      redirect '/login'
    end
  end


  post '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      if !recipe_fields_empty?
        @recipe = Recipe.create(name: params[:recipe][:name], content: params[:recipe][:content], user_id: current_user.id)

        @ingredient = Ingredient.create(name: params[:ingredient][:name])

        @recipe.ingredients << Ingredient.create(name: params[:ingredient][:name],user_id: current_user.id, recipe_id: current_recipe)

        @recipe_ingredients = Ingredient.create(name: params[:ingredient][:name])

        @recipe.recipe_ingredients << RecipeIngredient.create(params[:recipe_ingredient][:quantity], user_id: current_user.id, recipe_id: current_recipe, ingredient_id: current_ingred)

        redirect "/recipes/#{@recipe.id}"
      else
        redirect '/new'
      end
    else
      redirect '/recipes/failure'
    end
  end


  get '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      if @user.id == current_user.id
        @recipe = Recipe.find_by_id(params[:id])
        @recipe.ingredient = Ingredient.find_by_id(params[:id])
        @recipe.recipe_ingredient = RecipeIngredient.find_by(params[:id])
        erb :'/recipes/show_recipe', default_layout
      else
      redirect 'users/error'
    end
    else
      redirect '/login'
    end
  end


  get '/recipes/:id/edit' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])
      erb :'/recipes/edit_recipe', default_layout
    else
      redirect '/login'
    end
  end

  patch '/recipes/:id' do
    if logged_in? && !recipe_fields_empty?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])

      if !params[:recipe][:name].empty?
        @recipe.update(name: params[:recipe][:name])
      elsif !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @ingredient = Ingredient.update(name: params[:ingredient][:name])
        @recipe.recipe_ingredients = RecipeIngredient.update(quantity: params[:recipe_ingredient][:quantity])
      elsif !params[:recipe][:content].empty?
        @recipe.update(content: params[:recipe][:content])
      end
      @recipe.save
      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end

  get '/recipes/:id/add' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])

      erb :'/recipes/new_ingredient', default_layout
    else
      redirect '/login'
    end
  end

  post '/recipes/:id' do
    if logged_in? && !recipe_fields_empty?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])

      @ingredient = Ingredient.find_by_id(params[:id])
      @recipe_ingredient = RecipeIngredient.find_by_id(params[:id])
      if !params[:ingredient][:name].empty? && !params[:recipe_ingredient][:quantity].empty?
        @ingredient = Ingredient.create(name: params[:ingredient][:name])

        # @recipe << Ingredient.create(name: params[:ingredient][:name])
        @recipe.recipe_ingredients << RecipeIngredient.create(quantity: params[:recipe_ingredient][:quantity])

        @recipe.save
        redirect "/recipes/#{@recipe.id}"
      else
        redirect '/recipes/failure'
      end
    else
      redirect '/login'
    end
  end

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
