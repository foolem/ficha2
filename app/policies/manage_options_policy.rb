class ManageOptionsPolicy < ApplicationPolicy

  def index?
    !user.blank? and (user.admin? and user.actived?)
  end

  def search?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def find_pdf?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def send_ficha2_email?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def add_shortname?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def shortname?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def generate?
    user_admin_or_adviser? and !Semester.current_semester.options_generated
  end

  def send_email?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def all_records?
    !user.blank? and (user.has_any_role? ["admin", "secretary"] and user.actived?)
  end

  def remove?
    (user.has_any_role? ["secretary", "admin"] and user.actived?) and Semester.current_semester.options_generated
  end

  def start?
    (user.has_any_role? ["secretary", "admin"] and user.actived?) and Semester.current_semester.options_generated
  end

  def end?
    (user.has_any_role? ["secretary", "admin"] and user.actived?) and Semester.current_semester.options_selection
  end

  def teacher_report?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def final_report?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def matter_report?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def delivery?
    (user.has_any_role? ["secretary", "admin"] and user.actived?) && Semester.current_semester.options_generated
  end

  def select_teacher?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def edit_teacher?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def choose_teacher?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def edit_class_room?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def choose_class_room?
    (user.has_any_role? ["secretary", "admin"] and user.actived?)
  end

  def user_admin_or_adviser?
    !user.blank? and (user.has_any_role? ["admin", "adviser"] and user.actived?)
  end

  class ScopeManage < Scope
    def resolve
      scope
    end
  end
end
