class RecipesController  < ApplicationController

#user recipes
  get '/recipes' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipes = Recipe.all
      erb :'/recipes/all_recipes'
    else
      redirect '/login'
    end
  end

  get '/recipes/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'recipes/create'
    else
      redirect '/login'
    end
  end

  post '/recipes' do
    # @recipe = Recipe.create(params[:recipe])
    #Add new recipe names
    if !params[:name].empty?
      @recipe = Recipe.create(name: params[:name], user_id: current_user.id)
      redirect to "/recipes/#{@recipe.id}"
    else
      redirect to '/recipes/new'
    end
  end
    # if !params[:ingredient][:name].empty?
    #   @recipe.ingredients << Recingredient.create(params[:ingredient])
    # else
    #   redirect to '/recipes/new'
    # end



  get '/recipes/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @recipe = Recipe.find_by_id(params[:id])
      erb :'recipes/show'
    else
      redirect '/login'
    end
  end

  get '/recipes/:id/edit' do
    if logged_in?
      @recipe = Recipe.find_by_id(params[:id])
      erb :'/recipe/edit'
    else
      redirect '/login'
    end
  end

  # patch '/recipes/:id' do
  #   @recipe= Recipe.find_by_id(params[:id])
  #   # @landmark.update(params[:landmark])
  #   # @recipe.update(name: params[:recipe][:name], year_completed: params[:landmark][:year_completed])
  #   @recipe.save
  #   redirect "/recipe/#{@recipe.id}"
  # end


  #   if logged_in?
  #     @recipe = Recipe.find_by_id(params[:id])
  #     @recipe.update(name: params[:name], content: params[:content])
  #     if !params[:name].empty? && !params[:content].empty?
  #       @recipe.save
  #       redirect "/recipes/#{@recipe.id}"
  #     else
  #       redirect "/recipes/#{@recipe.id}/edit"
  #     end
  #   else
  #     redirect '/login'
  #   end
  # end
  #
  # delete '/recipes/:id/delete' do
  #   if logged_in?
  #     @recipe = Recipe.find_by_id(params[:id])
  #     if @recipe && current_user.id == @recipe.user_id
  #       @recipe.delete
  #       redirect '/all_recipes'
  #     end
  #   elsif !logged_in?
  #     redirect "/login"
  #   else
  #     redirect "/recipe/#{@recipe.id}"
  #   end
  # end

end
