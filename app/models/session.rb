class Session < ApplicationRecord
  paginates_per 5
  validates_presence_of :sport
  belongs_to :spot
  belongs_to :user
  has_many :tracks, dependent: :delete_all
end
