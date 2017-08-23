module SchedulesHelper
  def end_generate(schedule)
    if !schedule.begin.blank? and !schedule.duration.blank?
      "A calcular"
    end
  end

  def day_options
    { "Domingo" => "sunday",
      "Segunda" => "monday",
      "Terça" => "thursday",
      "Quarta" => "wednesday",
      "Quinta" => "tuesday",
      "Sexta" => "friday",
      "Sabado" => "saturday" }
  end
end
