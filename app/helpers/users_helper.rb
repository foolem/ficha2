module UsersHelper

  def users_order
    @teachers = User.all.where(actived: true).order(name: :asc)
    # adicionar verificação para nao pegar secretarios.... Join(:role)
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

  def user_admin_or_adviser?
    !user.blank? and (user.has_any_role? ["admin", "adviser"] and user.actived?)
  end

  def user_name_or_shortname?(ficha)
    User.find(ficha.appraiser_id).shortname.blank? ? User.find(ficha.appraiser_id).name : User.find(ficha.appraiser_id).shortname
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

  def wishes_ordered(user)
    current_wishes = []
    user.wishes.each do |w|
      if w.semester_id == Semester.current_semester.id
        current_wishes.push w
      end
    end
    current_wishes.sort_by { |w| w.priority }

  end

  def wishes_ordered_report(user, semester)
    current_wishes = []
    user.wishes.each do |w|
      if w.semester_id == semester
        current_wishes.push w
      end
    end
    current_wishes.sort_by { |w| w.priority }

  end

  def user_delivery
    users = []
    undefined = User.where(name: "Não definido")
    users.push undefined.first
    User.all.each do |u|
      if u.name == "Não definido"
        next
      end
      users.push u
    end
    users
  end

end
