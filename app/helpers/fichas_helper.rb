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


  def hasEquivalent(ficha)

    !ficha.blank? and !Ficha.where("matter_id = #{ficha.matter.id}").where('status = "Aprovado"').blank?
  end

  def getEquivalent(ficha)
    if !ficha.blank? and !ficha.matter.blank?
      Ficha.where("matter_id = #{ficha.matter.id}").where('status = "Aprovado"')
    end
  end

  def getMatter(ficha)
    "#{ficha.matter.code}  - #{ficha.matter.name}"
  end

  def getYears()

    years = {}
    year = Time.zone.now.year
    month = Time.zone.now.month

    6.times do |y|
      i = -6 +y
      years["1º de #{year+i}"] = "1#{year+i}"
      years["2º de #{year+i}"] = "2#{year+i}"
    end
    years["1º de #{year}"] = "1#{year}"
    if month > 5
      years["2º de #{year}"] = "2#{year}"
    end

    years['Todos Semestres'] = ''
    return years.to_a.reverse.to_h
  end

  def getYear

    year = Time.zone.now.year
    month = Time.zone.now.month

    if month > 5
      "2#{year}"
    else
      "1#{year}"
    end
  end

  def show_ficha
    @show = true
  end

  def can_not_edit(ficha)
    @show or (user_appriser and ficha.user.id != current_user.id)
  end

  #<td><center><%= ficha.created_at.strftime("%d/%m/%Y") %></center></td>

end
