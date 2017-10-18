module AvailabilitiesHelper

  def unavailabilities_day(day)
    @unavailabilities = Unavailability.joins(:schedule).where("schedules.day = #{day} and availability_id = #{@availability.id}")
    nil
  end

  def preferences
    ["Aulas geminadas", "Aulas em mesmo dia", "Sextas livres", "Segundas livres", "Aulas em mesmo periodo"]
  end

end
