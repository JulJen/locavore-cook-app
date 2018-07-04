class Ingredient < ActiveRecord::Base
  has_many :recipes_ingredients
  has_many :recipes, through: :recipe_ingredients

  # include ActiveModel::Validations
  #
  # validates :name, length: { minimum: 3, maximum: 20 }
end
