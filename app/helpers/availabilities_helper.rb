module AvailabilitiesHelper

  def unavailabilities_day(day)
    @unavailabilities = Unavailability.joins(:schedule).where("schedules.day = #{day} and availability_id = #{@availability.id}")
    nil
  end
end
