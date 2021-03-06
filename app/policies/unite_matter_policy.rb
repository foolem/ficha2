class UniteMatterPolicy < ApplicationPolicy


  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def edit?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def add?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def remove?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def show?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def update?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def destroy?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end


  class ScopeUniteMatter < Scope
    def resolve
      scope
    end
  end
end
