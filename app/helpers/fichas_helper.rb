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

  def count_lines(text)
    ((text.length / 80) + text.lines.count)
  end

end
