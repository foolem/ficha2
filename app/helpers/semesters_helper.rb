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

  def current_semester
    Semester.current_semester
  end

end
