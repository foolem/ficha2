class UserPolicy < ApplicationPolicy

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    true
  end

  def update?
    # aqui autoedit?
    puts "Record: #{record}"
    user.admin? or recor == user
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
