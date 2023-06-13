class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend

  def index
  end
end