class ManageOptionPolicy < ApplicationPolicy

  def index?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def remove?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def start?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def end?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def generate?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end



  class ScopeManage < Scope
    def resolve
      scope
    end
  end
end
