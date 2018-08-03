class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  def slug
   self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    Recipe.all.find{|name| name.slug == slug}
  end

end
