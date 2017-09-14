module CoursesHelper
  def courses_order
    Course.all.order(name: :asc)
  end
end
