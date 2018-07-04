class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient

  # user has_many :recipes
  # recipe h.m. recipe_ingredients
  # recipe hm ingredients, through RI
  # ingredient hm recipe ingredients
  # ingredient hm recipes through RI

end
