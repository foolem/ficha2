class PerformBackupPolicy < ApplicationPolicy


  def update?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def do_perform?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end


  class ScopeBackup < Scope
    def resolve
      scope
    end
  end
end
