class OptionPolicy < ApplicationPolicy

  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)

  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)

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
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def generate?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def open_wish?
    !user.blank? and !user.has_role?("secretary")
  end

  def open_comment?
    !user.blank?
  end

  def show?
    !user.blank?
  end


  class ScopeOption < Scope
    def resolve
      scope
    end
  end
end
