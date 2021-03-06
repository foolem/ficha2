module ApplicationHelper
  include Paginator

  def status_ready(status)
    status == "ready"
  end

  def record_edditable(status)
    user_signed_in? && status != "ready"
  end

  def count_lines(text)

    if(!text.blank?)
      return ((text.length / 80) + text.lines.count)
    end
    return 2
  end

  def bar_active
    classes = {}
    classes[session[:page]] = session[:page].blank? ? "home" : "active"
    classes
  end



  #------- button_configs

  def remove_configs_default
    confirm = { :confirm => "Você tem certeza?" }
    {:method => :delete, :data => confirm }
  end

  def button_configs(key, classes = nil, args = nil)
    tip = {new: "Adicionar", edit: "Editar", choose: "Escolher avaliador", remove: "Remover", begin: "Iniciar", select: "Selecionar", download: "Baixar", confirm: "Confirmar"}

    configs = {
      class: "btn-sm #{classes}",
      'data-toggle' => 'tooltip',
      'data-placement': 'right'
    }

    configs[:title] = tip[key.to_sym]

    if !args.blank?
      configs.merge!(args)
    end

    configs
  end

#-------
end
