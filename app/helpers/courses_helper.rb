module CoursesHelper
  def courses_order
    Course.all.order(name: :asc)
  end

  def courses_not_united
    return Course.all
  end

end
