class Semester < ApplicationRecord
  has_many :group

  def semester_with_year
    "#{semester}º de #{year}"
  end

  def semester_with_year_code
    "#{year}#{semester}"
  end

end
