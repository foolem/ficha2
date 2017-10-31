class FichaPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def edit?
    !user.blank? and (user.has_any_role? ["secretary", "teacher"] and user.actived?)
  end

  def update?
    !user.blank? and (user.has_any_role? ["secretary", "teacher"] and user.actived?)
  end

  def copy?
    !user.blank? and (user.has_any_role? ["secretary", "teacher"] and user.actived?)
  end

  def destroy?
    !user.blank? and (user.has_any_role? ["secretary", "teacher"] and user.actived?)
  end

  def show?
    true
  end


  class ScopeFicha < Scope
    def resolve
      scope
    end
  end
end
