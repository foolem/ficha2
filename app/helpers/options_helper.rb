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

  def option_schedules2(option)
    result = ""
    length = option.schedules.length
    if length > 0
      option.schedules.distinct.each do |schedule|
        text = "<span> #{representation(schedule)} </span> <br/> "
        result << text

      end
      if length == 1
        result << "</br>"
      end

    else
      result = "<span>Nenhum horário definido <br></br> </span>"
    end
    result
  end

  def option_schedules_inline(option)
    result = ""
    length = option.schedules.length
    if length > 0
      option.schedules.distinct.each do |schedule|
        text = "<span> #{representation(schedule)} </span>/ "
        result << text

      end
      if length == 1
        result << "</br>"
      end

    else
      result = "<span>Nenhum horário definido <br></br> </span>"
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

  def matter_group(matter)

    if matter.unite_matter.blank?
      return matter.name_with_code
    end

    result = "#{matter.unite_matter.name}: "
    matters = matter.unite_matter.matters
    matters.length.times do |i|
      matt = matters[i]
      if i != 0
        result << ", "
      end
      result << "#{matt.code}"
    end

    return result
  end

  def matter_options(matter)
    @options = []
    conn = ActiveRecord::Base.connection
    q = query(matter)
    if !q.blank?
      result = conn.execute q
      result.each do |option_id|
        opt = Option.find(option_id[0])
        @options << opt
      end
    end
  end

  def query(matter)
    if matter.unite_matter.blank?
      simple_query(matter)
    elsif !@unites.include? matter.unite_matter
      @unites << matter.unite_matter
      unite_query(matter)
    end
  end

  def unite_query(matter)
    "SELECT DISTINCT options.id FROM options
    inner join groups on options.id = groups.option_id
    inner join matters on groups.matter_id = matters.id
    where matters.unite_matter_id = #{matter.unite_matter.id}"
  end

  def simple_query(matter)
    "SELECT DISTINCT options.id FROM options
    inner join groups on options.id = groups.option_id
    where groups.matter_id = #{matter.id}"
  end

  def comments_length
    @option.comments
  end

  def has_optition_semester(semester)
    Option.count("semester_id = #{semester.id}") > 0
  end

end
