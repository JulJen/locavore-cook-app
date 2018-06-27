class User < ActiveRecord::Base
  # has_many :recipes
  # has_many :ingredients, through: :recipes
  # has_secure_password

  has_many :ingredients
  has_many :recipes, through: :ingredients
  has_secure_password




  # include ActiveModel::Validations
  #
  # validates :name, length: { minimum: 1, maximum: 10 }
  # validates :username, format: { without: /\s/ }
  # validates :password, length: { in: 1..10 }
  # validates :state, length: { minimum: 2, maximum: 2 }
  # validates :content, length: { minimum: 3, maximum: 50 }


  def slug
   self.username.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    User.all.find{|username| username.slug == slug}
  end

end
