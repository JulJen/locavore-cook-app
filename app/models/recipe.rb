class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients


  # include ActiveModel::Validations

  # validates :name, length: { minimum: 3, maximum: 20 }
  # validates :content, length: { minimum: 3, maximum: 50 }

  def slug
   self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    Recipe.all.find{|name| name.slug == slug}
  end

end
