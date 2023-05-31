class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.friendships.order(created_at: :desc)
    @users = User.where.not(id: (@friendships.map { |f| f.friend.id } << current_user.id)).order(:name)
  end

  def create
    Friendship.create!(user: current_user, friend: User.find(params[:id]))
    redirect_to friends_url
  end

  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to friends_url
  end

end
