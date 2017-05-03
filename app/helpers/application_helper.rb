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




  def render_pages(list, page)
    resto = pages_count(list.length)
    if(page.blank?)
      page = 1;
    end

    disable = 'class="disabled"'
    active = 'class="active"'
    first_page = '<li><a href="/fichas?page=5">5</a></li>'

      ṕre_page =
      '<li #>
        <a href="#" aria-label="Previous">
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>'

      next_page =
      '<li>
        <a href="#" aria-label="Next">
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>'

      result = pre_page + ' ' + page_1 + ' ' +
               page_2 + ' ' + page_3 + ' ' +
               page_4 + ' ' + page_5 + ' ' +
               next_page

    return result
  end

  def pages_count(num)
    pages = num/10
    resto = num.remainder 10
    if( resto >= 0)
      pages=pages+1
    end

    pages
  end

end
