module TeachersHelper

  def users_order
    @teachers = User.all.where("role = 0").where(actived: true).order(name: :asc)
  end
end
