class Ingredient < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :recipes

  # has_many :recipe_ingredients
  # has_many :recipes, through: :recipe_ingredients
  # has_many :users, through: :recipes
  # CRUD
  # If the table has a name column, it generates name, and name=
  # Save the item
end
