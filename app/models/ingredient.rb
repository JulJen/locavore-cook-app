class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  include ActiveModel::Validations
  validates :name, presence: true

end
