class ApplicationController < ActionController::Base
  include Pundit
  include Paginator
  include Searcher

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para acessar esta página."
    redirect_to(request.referrer || root_path)
  end


end
