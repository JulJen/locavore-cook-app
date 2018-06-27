class Recipe < ActiveRecord::Base
  # belongs_to :user
  # has_many :ingredients

  has_many :ingredients
  has_many :users, through: :ingredients




  # CRUD
  # If the table has a name column, it generates name, and name=
  # Save the item

  include ActiveModel::Validations

  validates :name, length: { minimum: 3, maximum: 20 }
  # validates :content, length: { minimum: 3, maximum: 50 }

  def slug
   self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    Recipe.all.find{|name| name.slug == slug}
  end

end
