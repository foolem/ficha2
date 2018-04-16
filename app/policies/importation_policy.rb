class ImportationPolicy < ApplicationPolicy


  def courses?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def groups?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def import_courses?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def import_groups?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def index?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end



  class ScopeImportation < Scope
    def resolve
      scope
    end
  end
end
