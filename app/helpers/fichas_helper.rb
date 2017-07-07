module FichasHelper

  def status_representation(status)
    if(status == "Aprovado")
      return getIcon("glyphicon glyphicon-ok", "Aprovado", "green")
    elsif (status == "Enviado")
      return getIcon("glyphicon glyphicon-refresh", "Enviado", "blue")
    elsif (status == "Editando")
      return getIcon("glyphicon glyphicon-pencil", "Editando", "black")
    else
      return getIcon("glyphicon glyphicon-ban-circle", "Reprovado", "red")
    end
  end


  def getIcon(style, tip, color)
    return "<i class='#{style}' style='color: #{color}' title ='#{tip}' data-toggle = 'tooltip' data-placement = 'right'></i>"
  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end

  def getYears()
    years = {'Todos' => ''}

    10.times do |y|
      i = 8 -y
      years[Time.zone.now.year-i] = Time.zone.now.year-i
    end

    return years
  end

  def show_ficha
    @show = true
  end

  def can_not_edit(ficha)
    @show or (user_appriser and ficha.user.id != current_user.id)
  end

  #<td><center><%= ficha.created_at.strftime("%d/%m/%Y") %></center></td>

end
