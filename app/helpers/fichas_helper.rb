module FichasHelper

  def status_representation(ficha)
    if(ficha.ready?)
      return getIcon("glyphicon glyphicon-ok", "Aprovado", "green")
    elsif (ficha.sent?)
      return getIcon("glyphicon glyphicon-refresh", "Enviado", "blue")
    elsif (ficha.editing?)
      return getIcon("glyphicon glyphicon-pencil", "Editando", "black")
    else
      return getIcon("glyphicon glyphicon-ban-circle", "Reprovado", "red")
    end
  end

  def getIcon(style, tip, color)
    return "<i class='#{style}' style='color: #{color}' title ='#{tip}' data-toggle = 'tooltip' data-placement = 'right'></i>"
  end

  def hasEquivalent(ficha)
    !ficha.blank? and !getEquivalent(ficha).blank?
  end

  def getEquivalent(ficha)
    if !ficha.blank? and !ficha.group.matter.blank?
      result = []
      groups = Group.where("matter_id = #{ficha.group.matter.id}")
      groups.each do |group|
        if group.ficha.ready?
          result << group.ficha
        end
      end
    end
    result
  end

  def getMatter(ficha)
    "#{ficha.group.matter.code}  - #{ficha.group.matter.name}"
  end

  def getYears(option)

    years = {}
    year = Time.zone.now.year
    month = Time.zone.now.month

    (year-2017).times do |i|
      years["1º de #{2017+i}"] = "1#{2017+i}"
      years["2º de #{2017+i}"] = "2#{2017+i}"
    end

    years["1º de #{year}"] = "1#{year}"
    if month > 5
      years["2º de #{year}"] = "2#{year}"
    end

    if option
      years['Todos semestres'] = ''
    end

    return years.to_a.reverse.to_h
  end

  def getYear(ficha)
    if ficha.blank? or (ficha.semester.blank? and ficha.year.blank?)
      year = Time.zone.now.year
      month = Time.zone.now.month

      if month > 5
        "2#{year}"
      else
        "1#{year}"
      end
    else
      "#{ficha.semester}#{ficha.year}"
    end
  end

  def show_ficha
    @show = true
  end

  def new_record
    @new = true
  end

  def can_not_edit(ficha)
    @show or (user_appriser and ficha.user.id != current_user.id)
  end

  #<td><center><%= ficha.created_at.strftime("%d/%m/%Y") %></center></td>

end
