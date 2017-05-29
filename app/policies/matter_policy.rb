class MatterPolicy < ApplicationPolicy

  def new?
    user.admin? or user.secretary?
  end

  def create?
    user.admin? or user.secretary?
  end

  def edit?
    user.admin? or user.secretary?
  end

  def update?
    user.admin? or user.secretary?
  end

  def destroy?
    user.admin? or user.secretary?
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
