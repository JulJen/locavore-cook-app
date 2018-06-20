class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients

  # has_many :recipe_ingredients
  # has_many :ingredients, through: :recipe_ingredients

  # CRUD
  # If the table has a name column, it generates name, and name=
  # Save the item

end
