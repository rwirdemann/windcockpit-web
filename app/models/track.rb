# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :user
  belongs_to :session
end
