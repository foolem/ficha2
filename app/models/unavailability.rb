class Unavailability < ApplicationRecord
  belongs_to :availability
  belongs_to :schedule, optional: true

  accepts_nested_attributes_for :schedule

  def self.user_unavailabilities_of_day(day, user)
    Unavailability.joins(:availability, :schedule).where("schedules.day = #{day} and user_id = #{user.id}")
  end
end
