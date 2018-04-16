class Schedule < ApplicationRecord

  enum day: [:sunday, :monday, :thursday, :wednesday, :tuesday, :friday, :saturday]

  has_and_belongs_to_many :groups
  has_many :unavailabilities

  def self.days
    [:sunday, :monday, :thursday, :wednesday, :tuesday, :friday, :saturday]
  end

  def day_to_i
    {"sunday" => 0, "monday" => 1, "thursday" => 2, "wednesday" => 3, "tuesday" => 4, "friday" => 5, "saturday" => 6}[day]
  end

  def parse_to_time
    self.begin = self.begin.to_time
    self.duration = self.duration.to_time
  end

  def self.find_by_users_and_day(user, day)
    Schedule.joins(unavailabilities: :availability)
    .where("availabilities.user_id = #{user.id}")
    .where("availabilities.semester_id = #{Semester.current_semester.id}")
    .where("schedules.day = #{day} ")
  end

  def end
    return self.begin + self.duration.hour.hours + self.duration.min.minutes
  end

end
