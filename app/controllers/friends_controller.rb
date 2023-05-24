class FriendsController < ApplicationController
  def index
    @friends = User.all
  end
end
