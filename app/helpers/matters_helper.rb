module MattersHelper

  def matters_order
    @matters = Matter.where(actived: true).order(name: :asc)
  end

end
