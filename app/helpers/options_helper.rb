module OptionsHelper

  def option_matters(option)
    result = ""

    option.matters.distinct.each do |matter|
      text = "<span> #{matter.code} </span> </br>"
      result << text
    end
    result
  end

  def option_matters_inline(option)
    result = ""

    option.matters.distinct.each do |matter|
      text = "#{matter.code} "
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

  def option_classes_with_course(option)
    result = ""
    option.groups.each do |group|
      text = "<span> #{group.matter.code} - #{group.name} - #{group.course.name} </span> </br>"
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
    @unites = [] # estudar esse erro de duplicação de turmas
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
    if @semester_id.blank?
      @semester_id = Semester.current_semester.id
    end

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
    inner join semesters on semesters.id = options.semester_id
    where matters.unite_matter_id = #{matter.unite_matter.id}
    and options.semester_id = #{@semester_id}"
  end

  def simple_query(matter)
    "SELECT DISTINCT options.id FROM options
    inner join groups on options.id = groups.option_id
    inner join semesters on semesters.id = options.semester_id
    where groups.matter_id = #{matter.id} and options.semester_id = #{@semester_id}"
  end

  def comments_length
    @option.comments
  end

  def has_optition_semester(semester)
    Option.count("semester_id = #{semester.id}") > 0
  end

  def schedules_report(option)

    schedule_list = {}

    option.schedules.distinct.each do |schedule|
      item = "#{schedule.begin.strftime("%H:%M")} - #{schedule.end.strftime("%H:%M")}"
      if !schedule_list[item].blank?
        schedule_list[item] = schedule_list[item] + [schedule.day_to_i + 1]
      else
        schedule_list[item] = [schedule.day_to_i + 1]
      end
    end
    result = schedule_list.map do |key, value|
      days = value.collect { |v| "#{v}a"  }.join(", ")
      "#{days} #{key}"
    end

    return result.join(" e ")
  end

  def hidden_fields(option)
     option.groups.distinct.each do |group|
       if group.course.name == "Honors"
         hidden = "display:none;"
         return hidden
       else
         return ""
       end
     end
  end

  def hidden_groups(group)
    if group.active == false
      hidden = "display:none;"
      return hidden
    else
      return
    end
  end

end
