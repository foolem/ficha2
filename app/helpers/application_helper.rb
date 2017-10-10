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
    classes.each{ |chr| puts chr  }
    classes
  end

end
