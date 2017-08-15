module SemestersHelper

  def semester_order
    Semester.all.order(id: :desc)
  end

  def semester_options()
    current_semester

    options = {}
    options['Todos semestres'] = ''
    semester_order.each do |semester|
      options[semester.semester_with_year] = semester.id
    end

    return options
  end

  def current_semester()

    current_year = Time.zone.now.year
    current_semester = 1

    if Time.zone.now.month > 5
      current_semester = 2
    end

    semester = Semester.where(semester: current_semester, year: current_year)[0];
    if semester.blank?
      puts "Não achei esse semestre: #{current_semester}º de #{current_year}"
      semester = Semester.create(semester: current_semester, year: current_year);
    end
    semester
  end

end
