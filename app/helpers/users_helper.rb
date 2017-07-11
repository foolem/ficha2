module UsersHelper

  def users_order
    @teachers = User.all.where("role != 3").where(actived: true).order(name: :asc)
  end

end
