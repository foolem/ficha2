class ControlUsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    authorize @users
  end
end
