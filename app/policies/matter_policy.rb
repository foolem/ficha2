class MatterPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived? and !user.teacher?)
  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived? and !user.teacher?)
  end

  def edit?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived? and !user.teacher?)
  end

  def update?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived? and !user.teacher?)
  end

  def destroy?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived? and !user.teacher?)
  end

  def show?
    true
  end


  class ScopeMatter < Scope
    def resolve
      scope
    end
  end
end
