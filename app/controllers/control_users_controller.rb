class ControlUsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where("role = 1 or role = 2")
    authorize @users
  end

end
