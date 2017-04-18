module MattersHelper

  def matters_order
    @matters = Matter.all.order(name: :asc)
  end

end
