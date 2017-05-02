module ApplicationHelper
  def user_teacher
    user_signed_in? && current_user.teacher?
  end

  def user_not_teacher
    user_signed_in? && !current_user.teacher?
  end

  def user_not_teacher_not_logged
    user_not_teacher or !user_signed_in?
  end

  def user_appriser
    user_signed_in? && current_user.appraiser?
  end

  def user_not_appriser
    user_signed_in? && !current_user.appraiser?
  end

  def user_admin
    user_signed_in? && current_user.admin?
  end

  def user_not_admin
    user_signed_in? && !current_user.admin?
  end

  def status_ready(status)
    status == "Aprovado"
  end

  def record_edditable(status)
    user_signed_in? && status != "Aprovado"
  end

  def remove_button
    '<i class="glyphicon glyphicon-remove"></i>'
  end

  def edit_button
    '<i class="glyphicon glyphicon-edit"></i> Editar'
  end

  def new_button
    '<i class="glyphicon glyphicon-plus"></i>'
  end
  def download_button
    '<i class="glyphicon glyphicon-save"></i> Baixar'
  end

end
