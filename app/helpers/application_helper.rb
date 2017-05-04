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
    pages = pages_count(list)

    if(pages < 1)
      return ' '
    end
    page = page.to_i
    if(page.blank? or page == 0 )
      page = 1;
    end

    inicial = 1
    if(page >= 4)
      inicial = page - 2

      if page + 2 > pages
        inicial -= 2
      end

    end

    if page == inicial + 4 && inicial + 5 <= pages
      inicial += 1
    end

    maximo = inicial + 4
    if(pages < 5)
      maximo = pages
    end

    resultado = ' '
    for i in inicial..maximo
      if i == page
        puts "Page: #{page}"
        puts "I: #{i}"
        resultado = resultado + ' <li class="active black"><a href="/fichas?page=' + i.to_s + '">' + i.to_s + '</a></li>'
      else
        resultado = resultado + ' <li><a href="/fichas?page=' + i.to_s + '">' + i.to_s + '</a></li>'
      end
    end

      if(page <= 1)
        classe = 'class="disabled"'
        puts "Page: #{page}"
        link = "/fichas?page=#{page.to_s}"
      else
        classe = ''
        link = "/fichas?page=#{(page-1).to_s}"
      end

      pre_page ='<li '+ classe +' > <a href="'+ link +
      '" aria-label="Previous"> <span aria-hidden="true">&laquo;</span> </a> </li>'

      if(page >= pages)
        classe = 'class="disabled"'
        link = "/fichas?page=#{page.to_s}"
      else
        classe = ''
        link = "/fichas?page=#{(page+1).to_s}"
      end

      next_page =
      '<li '+ classe +' > <a href="'+ link +
      '" aria-label="Next"> <span aria-hidden="true">&raquo;</span> </a> </li>'

      result = pre_page +' '+ resultado +' '+ next_page

    return result
  end

  def pages_count(num)
    pages = num/10
    resto = num.remainder 10
    if( resto > 0)
      pages=pages+1
    end
    pages
  end

end
