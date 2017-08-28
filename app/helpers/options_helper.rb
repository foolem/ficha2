module OptionsHelper

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

    option.schedules.each do |schedule|
      text = "<span> #{representation(schedule)} </span> </br>"
      result << text
    end
    result
  end

  def options_generate
    Group.all.each do |group|

      if !has_option(group)
        option = Option.new

        same_groups(group).each do |same_group|
          option.groups << same_group
        end

        option.save

      end
    end
  end

  def same_groups(group)
    list = Group.where(matter: group.matter)
    result = []

    schedules = group.schedules

    list.each do |grp|
      if schedules == grp.schedules
        result << grp
      end
    end

    result
  end

  def x
    options = Option.all
    options.each do |opt|
      puts "------ Option: #{opt.id} ------"
      opt.groups.each do |group|
        puts "#{group.name} - #{group.matter.code}"
      end
      puts "-------------------------"
    end
  end

  def has_option(group)
    Option.all.each do |opt|
      if opt.groups.include? group
        return true
      end
    end
    return false
  end
end
