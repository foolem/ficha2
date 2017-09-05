class Semester < ApplicationRecord
  has_many :group
  has_many :option

  def semester_with_year
    "#{semester}º de #{year}"
  end

  def semester_with_year_code
    "#{year}#{semester}"
  end

  def self.current_semester

    current_year = Time.zone.now.year
    current_semester = 1

    if Time.zone.now.month > 5
      current_semester = 2
    end

    semester = Semester.where(semester: current_semester, year: current_year).first;
    if semester.blank?
      semester = Semester.create(semester: current_semester, year: current_year);
    end
    semester
  end

end
