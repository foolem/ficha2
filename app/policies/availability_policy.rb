class AvailabilityPolicy < ApplicationPolicy


  def new?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def edit?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def create?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def update?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def destroy?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def user_availability?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def open_unavailability?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def add_unavailability?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def select_preference?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def add_preference?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def change_preference?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end


  class ScopeAvailability < Scope
    def resolve
      scope
    end
  end
end
