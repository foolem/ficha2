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
    i = 1
    option.groups.each do |group|
      text = "<span> #{group.name} </span>"
      if i != option.groups.length
        text << "ou"
      end
      i = i + 1
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

end
