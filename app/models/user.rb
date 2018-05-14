class User < ActiveRecord::Base
  has_many :recipes
  has_many :ingredients, through: :recipes
  has_secure_password
  # CRUD
  # If the table has a name column, it generates name, and name=
  # Save the item

end
