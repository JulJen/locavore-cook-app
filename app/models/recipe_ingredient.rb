class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient

  include ActiveModel::Validations
  validates :name, presence: true

end
