class MatterPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
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
