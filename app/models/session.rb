class Session < ApplicationRecord
  paginates_per 5
  validates_presence_of :sport, :duration
  belongs_to :spot
  belongs_to :user
end
