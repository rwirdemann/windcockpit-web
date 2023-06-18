class ApplicationController < ActionController::Base
  include Authentication
  include SessionMembership

  def index
  end
end