class Semester < ApplicationRecord
  has_many :group
  has_many :option

  def semester_with_year
    "#{semester}º de #{year}"
  end

  def semester_with_year_show
    "#{semester}º semestre de #{year}"
  end

  def semester_with_year_code
    "#{year}#{semester}"
  end

  def self.current_semester

    current_year = Time.zone.now.year
    current_month = Time.zone.now.month

    current_semester = 1

    if current_month > 5
      current_semester = 2
    end

    if current_month > 10
      current_year += 1
      current_semester = 1
    end

    semester = Semester.where(semester: current_semester, year: current_year).first;
    if semester.blank?
      semester = Semester.create(semester: current_semester, year: current_year);
    end
    semester
  end

end
