class ManageOptionsPolicy < ApplicationPolicy

  def index?
    user_admin_or_adviser?
  end

  def search?
    !user.blank? and (user.has_any_role? ["admin", "secretary", "counselor"] and user.actived?)
  end

  def find_pdf?
    !user.blank? and (user.has_any_role? ["admin", "secretary", "counselor"] and user.actived?)
  end

  def send_ficha2_email?
    !user.blank? and (user.has_any_role? ["admin", "secretary", "counselor"] and user.actived?)
  end

  def generate?
    user_admin_or_adviser? and !Semester.current_semester.options_generated
  end

  def send_email?
    user_admin_or_adviser?
  end

  def remove?
    user_admin_or_adviser? and Semester.current_semester.options_generated
  end

  def start?
    user_admin_or_adviser? and Semester.current_semester.options_generated
  end

  def end?
    user_admin_or_adviser? and Semester.current_semester.options_selection
  end

  def teacher_report?
    user_admin_or_adviser?
  end

  def final_report?
    user_admin_or_adviser?
  end

  def matter_report?
    user_admin_or_adviser?
  end

  def delivery?
    user_admin_or_adviser? && Semester.current_semester.options_generated
  end

  def select_teacher?
    user_admin_or_adviser?
  end

  def edit_teacher?
    user_admin_or_adviser?
  end

  def choose_teacher?
    user_admin_or_adviser?
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
