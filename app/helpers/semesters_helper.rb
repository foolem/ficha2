module SemestersHelper

  def semester_order
    Semester.all.order(id: :desc)
  end

  def getSemesters()

    current_year = Time.zone.now.year
    current_semester = 1

    if Time.zone.now.month > 5
      current_semester = 2
    end
    
    semesters = semester_order
    if semesters.blank? or (semesters[0].semester_with_year != "#{current_semester}º de #{current_year}")
      Semester.create(semester: current_semester, year: current_year);
    end

    options = {}
    options['Todos semestres'] = ''
    semester_order.each do |semester|
      options[semester.semester_with_year] = semester.id
    end

    return options
  end

  def getSemester()


    current_year = Time.zone.now.year
    current_semester = 1

    if Time.zone.now.month > 5
      current_semester = 2
    end

    semester = Semester.last
    if !semester.blank? and (semester.year = current_year and semester.semester = current_semester)
      semester.id
    else
      semester = Semester.where(semester: current_semester, year: current_year)[0];
      if semester.blank?
        semester = Semester.new(semester: current_semester, year: current_year);
        semester.save
      end
      semester.id
    end
  end

end
