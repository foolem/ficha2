module SemestersHelper

  def semester_order
    Semester.all.order(id: :desc)
  end

  def semester_options
    current_semester

    options = {}
    options['Todos semestres'] = ''
    semester_order.each do |semester|
      options[semester.semester_with_year] = semester.id
    end

    return options
  end

  def semester_options_diff
    current_semester

    options = {}
    semester_order.each do |semester|
      options[semester.semester_with_year] = semester.id
    end

    return options
  end



  def current_semester
    Semester.current_semester
  end

  def options_not_generated?
    Semester.current_semester.options_generated?
  end

  def options_selection?

    !Semester.current_semester.options_selection and !Semester.current_semester.options_finished
  end

  def options_finished?

    Semester.current_semester.options_finished?
  end

  def options_started?

    Semester.current_semester.options_selection?
  end

end
