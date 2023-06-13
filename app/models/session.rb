class Session < ApplicationRecord
  validates_presence_of :sport
  belongs_to :spot
  belongs_to :user
  has_many :tracks, dependent: :delete_all
end
