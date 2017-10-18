class UserPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.admin? or user.secretary?)
  end

  def create?
    !user.blank? and (user.admin?  or user.secretary?)
  end

  def edit?
    !user.blank? and (user.admin?  or user.secretary?)
  end

  def update?
    !user.blank? and (user.admin?  or user.secretary?)
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
