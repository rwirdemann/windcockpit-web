class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @session = Session.find(params[:session_id])
    respond_to do |format|
      if @session.memberships.create(user_id: current_user.id, session_id: params[:session_id])
        format.turbo_stream
      end
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    respond_to do |format|
      @session = membership.session
      if membership.destroy
        @session = @session.reload
        format.turbo_stream
      end
    end
  end
end
