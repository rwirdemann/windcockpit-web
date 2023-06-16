class User < ApplicationRecord
  has_many :sessions

  has_many :memberships
  has_many :session_memberships, :through => :memberships, source: "session"

  has_many :friends, through: :friendships

  has_many :friendships
  has_many :friends, through: :friendships

  has_secure_password
  has_secure_password :apikey
  validates_presence_of :name
end
