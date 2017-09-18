module OptionsHelper

  def option_matters(option)
    result = ""

    option.matters.distinct.each do |matter|
      text = "<span> #{matter.code} </span> </br>"
      result << text
    end
    result
  end


  def option_classes(option)
    result = ""
    option.groups.each do |group|
      text = "<span> #{group.matter.code} - #{group.name} </span> </br>"
      result << text
    end
    result
  end

  def option_courses(option)
    result = ""
    option.groups.each do |group|
      text = "<span> #{group.course.name} </span> </br>"
      result << text
    end
    result
  end

  def option_schedules(option)
    result = ""

    option.schedules.distinct.each do |schedule|
      text = "<span> #{representation(schedule)} </span> </br>"
      result << text
    end
    result
  end

  def option_users(option)
    result = ""

    option.users.each do |user|
      text = "<span> #{user.name} </span> </br>"
      result << text
    end
    result
  end


  def comments_length
    @option.comments.length
  end

  def badgesComments_class
    result = "badges"
    if comments_length > 9
      result << "Two"
    elsif comments_length == 0
      result << " badgesNone"
    end
    result
  end

end
