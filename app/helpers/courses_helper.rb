module CoursesHelper
  def courses_order
    Course.all.order(name: :asc)
  end

  def courses_not_united
    courses = Course.all
    r_courses = []
    courses.each do |c|
      if !c.name.include? ","
        r_courses.push c
      end
    end
    return r_courses
  end

end
