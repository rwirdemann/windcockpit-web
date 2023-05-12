class Session < ApplicationRecord
  validates_presence_of :sport
  belongs_to :spot
end
