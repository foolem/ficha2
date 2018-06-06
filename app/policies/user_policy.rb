class UserPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def edit?
    !user.blank?
  end

  def update?
    !user.blank?
  end

  def destroy?
    !user.blank? and (user.has_role? ("admin") and user.actived?)
  end

  def show?
    !user.blank?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
