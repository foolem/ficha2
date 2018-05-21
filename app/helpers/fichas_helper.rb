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
        if !group.ficha.blank? and group.ficha.ready?
          result << group.ficha
        end
      end
    end
    result
  end

  def active_status(key)

    status = { "editing" => "btn btn-default btn-sm",
      "sent" => "btn btn-default btn-sm",
      "ready" => "btn btn-default btn-sm",
      "reproved" => "btn btn-default btn-sm" }

      if key == @ficha.status
        status[key] << " active"
      end

      status[key]
  end

  def status_options
    {"Encaminhado" => "sent", "Aprovado" => "ready", "Reprovado" => "reproved"}
  end

  def messages_length
    @ficha.messages.length-1
  end

  def badges_class
    result = "badges"
    if messages_length > 9
      result << "Two"
    elsif messages_length == 0
      result << " badgesNone"
    end
    result
  end

  def getMatter(ficha)
    "#{ficha.group.matter.code}  - #{ficha.group.matter.name}"
  end

  def options_status
    {"Encaminhado" => "sent", "Reprovado" => "reproved","Aprovado" => "ready"}
  end

  def show_ficha
    @show = true
  end

  def new_record
    @new_record = true
  end

  def can_not_edit(ficha)
    @show or (user_appriser? and ficha.user.id != current_user.id)
  end

  def appraisers
    appraisers = []
    User.all.each do |u|
      appraisers.push(u) if u.has_role?("appraiser")
    end
    appraisers
  end

  #<td><center><%= ficha.created_at.strftime("%d/%m/%Y") %></center></td>

end
