module FichasHelper

  def status_representation(status)
    if(status == "Aprovado")
      return "<i class='glyphicon glyphicon-ok' style='color: green'></i>"
    elsif (status == "Enviado")
      return "<i class='glyphicon glyphicon-refresh'></i>"
    else
      return "<i class='glyphicon glyphicon-ban-circle'style='color: red'></i>"
    end
  end

  def getSemester(ficha)
    return ficha.semester.to_s + " / " + ficha.year.to_s
  end

#<td><center><%= ficha.created_at.strftime("%d/%m/%Y") %></center></td>
end
