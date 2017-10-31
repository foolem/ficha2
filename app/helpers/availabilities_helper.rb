module AvailabilitiesHelper

  def unavailabilities_day(day)
    @unavailabilities = Unavailability.joins(:schedule).where("schedules.day = #{day} and availability_id = #{@availability.id}")
    nil
  end

  def preferences
    {"Concentrar minhas aulas pela manhã" => 0,
    "Concentrar minhas aulas à tarde" => 1,
    "Concentrar minhas aulas à noite" => 2,
    "Não dar aulas às 7:30" => 3, 
    "Não dar aulas à noite" => 4,
    "Concentrar todas minhas aulas em 2 ou 3 dias da semana" => 5,
    "Ficar apenas com disciplinas iguais" => 6, "Dar duas aulas em sequência" => 7,
    "Não dar duas aulas em sequência" => 8}
  end

  def researcher_options
    {"Não" => 0, "Sim" => 1}
  end

  def is_researcher
    answer = @availability.researcher
    if answer == true
      answer = "Sim"
    else
      answer = "Não"
    end
    answer
  end

  def preferences_not_choosed

    choosed = [@availability.preference_first, @availability.preference_second, @availability.preference_third]

    result = {}
    preferences.each do |key, value|
     if !choosed.include? value
       result[key] = value
     end
    end
    result
  end
end
