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

  def matter_options(matter)
    @options = []
    conn = ActiveRecord::Base.connection
    result = conn.execute "SELECT options.id FROM options inner join groups on options.id = groups.option_id inner join matters on groups.matter_id = matters.id where matters.id = #{matter.id}"
    result.each do |option_id|
      @options << Option.find(option_id[0])
    end
  end

  def comments_length
    @option.comments
  end



end
