class Course < ApplicationRecord
  has_many :groups

  def course_name
    return name
  end

end
