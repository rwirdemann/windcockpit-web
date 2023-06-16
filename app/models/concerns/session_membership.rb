module SessionMembership
  extend ActiveSupport::Concern

  included do
    helper_method :is_owner_or_member?
    helper_method :is_owner?
    helper_method :current_membership
  end

  def is_owner_or_member?(session)
    if session.user == current_user
      return true
    end

    return Membership.find_by(user_id: current_user.id, session_id: session.id)
  end

  def is_owner?(session)
    session.user == current_user
  end

  def current_membership(session)
    return Membership.find_by(user_id: current_user.id, session_id: session.id)
  end

end
