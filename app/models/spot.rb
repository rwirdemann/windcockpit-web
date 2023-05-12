class Spot < ApplicationRecord
  validates_presence_of :name
  has_many :sessions
end
