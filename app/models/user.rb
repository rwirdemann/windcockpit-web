class User < ApplicationRecord
  has_secure_password
  has_secure_password :apikey
  validates_presence_of :name
end
