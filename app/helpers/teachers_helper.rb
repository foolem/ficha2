module TeachersHelper

  def teachers_order
    @teachers = Teacher.all
    @teachers = @teachers.sort_by {|teacher| teacher.name}
  end
end
