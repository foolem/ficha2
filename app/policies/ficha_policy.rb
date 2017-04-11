class FichaPolicy < ApplicationPolicy

  def new?
    user.admin? or user.teacher?
  end

  def create?
    user.admin? or user.teacher?
  end

  def edit?
    user.admin? or user.appraiser?
  end

  def update?
    user.admin? or user.appraiser?
  end


  def destroy?
    user.admin?
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
