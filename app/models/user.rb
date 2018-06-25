class User < ActiveRecord::Base
  has_many :recipes
  has_many :ingredients
  # has_many :recipe_ingredients
  # has_many :ingredients, through: :recipe_ingredients
  has_secure_password
  # CRUD
  # If the table has a name column, it generates name, and name=
  # Save the item

  def slug
   self.username.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    User.all.find{|username| username.slug == slug}
  end

end
