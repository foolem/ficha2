class UserPolicy < ApplicationPolicy

  def index?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
