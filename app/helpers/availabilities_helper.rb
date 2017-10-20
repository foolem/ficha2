module AvailabilitiesHelper

  def unavailabilities_day(day)
    @unavailabilities = Unavailability.joins(:schedule).where("schedules.day = #{day} and availability_id = #{@availability.id}")
    nil
  end

  def preferences
    {"Aulas geminadas" => 0, "Aulas em mesmo dia" => 1, "Sextas livres" => 2, "Segundas livres" => 3, "Aulas em mesmo periodo" => 4}
  end

  def preferences_not_chosed

    chosed = [@availability.preference_first, @availability.preference_second, @availability.preference_third]

    result = {}
    preferences.each do |key, value|
     if !chosed.include? value
       result[key] = value
     end
    end
    result
  end
end
