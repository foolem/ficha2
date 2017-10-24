class UnavailabilityPolicy < ApplicationPolicy

  def create?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def update?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end

  def destroy?
    !user.blank? and (user.has_any_role? ["teacher", "secretary"] and user.actived?)
  end



  class ScopeUnavailability < Scope
    def resolve
      scope
    end
  end
end
