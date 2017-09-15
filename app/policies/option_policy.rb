class OptionPolicy < ApplicationPolicy

  def new?
    (user.admin? or user.secretary?) and user.actived?
  end

  def create?
    (user.admin? or user.secretary?) and user.actived?
  end

  def edit?
    !user.blank?
  end

  def search?
    !user.blank?
  end

  def update?
    !user.blank?
  end

  def destroy?
    (user.admin? or user.secretary?) and user.actived?
  end

  def generate?
    (user.admin? or user.secretary?) and user.actived?
  end

  def open_wish?
    !user.blank? and !user.secretary?
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
