class User < ApplicationRecord
  has_many :sessions

  has_many :friendships
  has_many :friends, through: :friendships

  has_secure_password
  has_secure_password :apikey
  validates_presence_of :name
end
