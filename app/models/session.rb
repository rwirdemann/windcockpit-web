class Session < ApplicationRecord
  validates_presence_of :sport, :duration
  belongs_to :spot
  belongs_to :user
end
