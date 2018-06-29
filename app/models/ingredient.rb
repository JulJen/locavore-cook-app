class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user

  # has_many :users, through: :recipes

  # include ActiveModel::Validations
  #
  # validates :name, length: { minimum: 3, maximum: 20 }
end

  # has_many :recipe_ingredients
  # has_many :recipes, through: :recipe_ingredients
  # has_many :users, through: :recipes
  # CRUD
  # If the table has a name column, it generates name, and name=
  # Save the item
