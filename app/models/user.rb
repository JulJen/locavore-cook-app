class User < ActiveRecord::Base
  has_secure_password
  has_many :recipes

  include ActiveModel::Validations
  validates :fname, length: { minimum: 1, maximum: 20 }
  validates :lname, length: { minimum: 1, maximum: 20 }
  validates :username,  uniqueness: true
  validates :fname, :lname, :username,  :email, presence: true


  def slug
   self.username.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
    User.all.find { |name| name.slug == slug }
  end

end
