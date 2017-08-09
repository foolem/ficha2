module SemestersHelper

  def semester_order
    Semester.all.order(created_at: :desc)
  end

end
