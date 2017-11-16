module SchedulesHelper

  def end_generate(schedule)
    if !schedule.begin.blank? and !schedule.duration.blank?
      hour = (schedule.duration.hour.to_i + schedule.begin.hour.to_i)
      min = (schedule.duration.min.to_i + schedule.begin.min.to_i)
    end

    if min > 60
      min -= 60
      hour += 1
    end

    date_show(hour, min)
  end

  def schedule_date_show(schedule)
    date = schedule.begin
    date_show(date.hour, date.min)
  end

  def date_show(hour, min)
    min_str = min == 0 ? "00" : min.to_s
    hour_str = hour == 0 ? "00" : hour.to_s

    if hour < 10 and hour > 0
      hour_str = "0#{hour}"
    end

    "#{hour_str}:#{min_str}"
  end

  def day_options
    { "Domingo" => "sunday",
      "Segunda" => "monday",
      "Terça" => "thursday",
      "Quarta" => "wednesday",
      "Quinta" => "tuesday",
      "Sexta" => "friday"}
  end

  def representation(schedule)
    "#{day_options.key(schedule.day)}, #{schedule_date_show(schedule)} - #{end_generate(schedule)}"
  end

end
