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

  def user_admin_or_secretary?
    user_signed_in? && (current_user.secretary? or current_user.admin?)
  end

  def user_not_teacher_not_logged?
    user_not_teacher or !user_signed_in?
  end

  def options_for_roles
    result  = {'Todos os tipos' => ''}
    roles = Role.all
    roles.each do |role|
        result[t(role.name)] = role.id
    end
    result
  end

  def role_selected?
    !params[:q].blank? and params[:q][:roles_id_eq].blank?
  end

end
