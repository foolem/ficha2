class UserPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def edit?
    true
  end

  def update?
    true
  end

  def destroy?
    !user.blank? and (user.has_role? ("admin") and user.actived?)
  end

  def show?
    true
  end

  class ScopeUser < Scope
    def resolve
      scope
    end
  end
end
