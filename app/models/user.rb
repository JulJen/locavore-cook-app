class User < ActiveRecord::Base
  has_secure_password
  has_many :recipes

  include ActiveModel::Validations
  validates :fname, length: { minimum: 1, maximum: 20 }
  validates :lname, length: { minimum: 1, maximum: 20 }
  validates :fname, :lname, :username,  :email, presence: true
  validates :username,  uniqueness: true
  validates :email,  uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_length_of :state, :maximum => 2

  # def slug
  #  self.username.gsub(" ", "-").downcase
  # end
  #
  # def self.find_by_slug(slug)
  #   User.all.find { |name| name.slug == slug }
  # end

end
