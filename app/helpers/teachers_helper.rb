module TeachersHelper

  def users_order
    @teachers = User.all.where("role = 0").order(name: :asc)
  end
end
