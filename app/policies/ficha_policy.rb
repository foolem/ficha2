class FichaPolicy < ApplicationPolicy

  def new?
    !user.blank? and ((user.admin? or user.secretary?) and user.actived?)
  end

  def create?
    !user.blank? and ((user.admin? or user.teacher?) and user.actived?)
  end

  def edit?
    !user.blank? and (user.admin? or user.appraiser? or user.teacher? or user.secretary?)
  end

  def update?
    !user.blank? and (user.admin? or user.appraiser? or user.teacher? or user.secretary?)
  end

  def copy?
    !user.blank? and (user.admin? or user.teacher? or user.secretary?)
  end

  def destroy?
    # teacher apenas em suas fichas
    !user.blank? and (user.admin? or user.teacher? or user.secretary?)
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
