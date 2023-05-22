class Session < ApplicationRecord
  validates_presence_of :sport, :duration
  belongs_to :spot
end
