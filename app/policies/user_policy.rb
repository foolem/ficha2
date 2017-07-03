class UserPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.admin?)
  end

  def create?
    !user.blank? and (user.admin?)
  end

  def edit?
    true
  end

  def update?
    true
  end

  def destroy?
    !user.blank? and (user.admin?)
  end

  def show?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
