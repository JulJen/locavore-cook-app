class RecipeIngredient <ActiveRecord::Base

  belongs_to :recipe
  belongs_to :ingredient

end

# has multiple ingredients and multiple recipes
