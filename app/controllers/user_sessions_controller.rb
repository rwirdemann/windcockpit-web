class UserSessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.find_by(name: params[:user][:name].downcase)
    if @user
      if @user.authenticate(params[:user][:password])
        login @user
        redirect_to root_path, notice: "Signed in."
      else
        flash.now[:alert] = "Incorrect name or password."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Incorrect name or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end
end
