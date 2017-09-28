module UsersHelper

  def users_order
    @teachers = User.all.where("role != 3").where(actived: true).order(name: :asc)
  end

  def user_teacher?
    user_signed_in? && current_user.teacher?
  end

  def user_appriser?
    user_signed_in? && current_user.appraiser?
  end

  def user_admin?
    user_signed_in? && current_user.admin?
  end

  def user_secretary?
    user_signed_in? && current_user.secretary?
  end

  def user_not_teacher?
    user_signed_in? && !current_user.teacher?
  end

  def user_not_appriser?
    user_signed_in? && !current_user.appraiser?
  end

  def user_not_admin?
    user_signed_in? && !current_user.admin?
  end

  def user_not_secretary?
    user_signed_in? && !current_user.secretary?
  end

  def user_not_teacher_not_logged?
    user_not_teacher or !user_signed_in?
  end

  def options_for_roles
    Role::ROLES.map do |key, value|
      OptionsForRoles.new(key, value)
    end

  end

end
