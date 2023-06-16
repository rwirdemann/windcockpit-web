class ApplicationController < ActionController::Base
  include Authentication
  include SessionMembership
  include Pagy::Backend

  def index
  end
end