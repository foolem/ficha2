module UnavailabilitiesHelper

  def default_array
    column = {}
    t = Time.parse("2000/01/01 7:00")
    while t.hour != Time.parse("2000/01/01 22:00").hour
      t += 30.minutes
      column["#{t.hour}:#{t.min}"] = false
    end
    column
  end

  def column_day(user, day)
    schedules = Schedule.find_by_users_and_day(user, day)

    column = default_array
    schedules.each do |sch|
      start = sch.begin
      finish = sch.begin + sch.duration.hour.hours + sch.duration.min.minutes
      new_start = start

      while new_start != finish
        column["#{new_start.hour}:#{new_start.min}"] = true;
        new_start += 30.minutes
      end

    end

    column
  end

end
