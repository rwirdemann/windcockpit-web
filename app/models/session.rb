class Session < ApplicationRecord
  paginates_per 5
  validates_presence_of :sport
  belongs_to :spot
  belongs_to :user
end
