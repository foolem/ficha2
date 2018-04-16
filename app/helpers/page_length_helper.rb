module PageLengthHelper

  def group_page_length
    if user_signed_in? and (current_user.admin? or current_user.secretary?)
      return 10
    end
    13
  end

  def ficha_page_length
    10
  end

  def course_page_length
    if user_signed_in? and (current_user.admin? or current_user.secretary?)
      return 10
    end
    13
  end

  def matter_page_length
    if user_signed_in? and (current_user.admin? or current_user.secretary?)
      return 10
    end
    13
  end

  def option_page_length
    30
  end

  def user_page_length
    if user_signed_in? and (current_user.admin? or current_user.secretary?)
      return 10
    end
    13
  end

end
