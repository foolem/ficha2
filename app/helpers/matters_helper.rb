module MattersHelper

  def matters_order
    @matters = Matter.all
    @matters = @matters.sort_by {|matter| matter.name}
  end

end
