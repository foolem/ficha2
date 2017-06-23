class FichaPolicy < ApplicationPolicy

  def new?
    (user.admin? or user.secretary?) and user.actived?
  end

  def create?
    (user.admin? or user.teacher?) and user.actived?
  end

  def edit?
    user.admin? or user.appraiser? or user.teacher?
  end

  def update?
    user.admin? or user.appraiser? or user.teacher?
  end

  def copy?
    user.admin? or user.teacher?
  end

  def destroy?
    # teacher apenas em suas fichas
    user.admin? or user.teacher?
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
