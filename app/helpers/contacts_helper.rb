module ContactsHelper
  def user_name
    if(user_signed_in?)
      current_user.name
    end
  end

  def user_email
    if(user_signed_in?)
      current_user.email
    end
  end

  def getTime
    Time.now.strftime("%d/%m/%Y %H:%M")
  end

end
