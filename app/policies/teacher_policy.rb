class TeacherPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin? or user.appriser?
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
