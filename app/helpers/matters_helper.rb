module MattersHelper

  def matters_order
    @matters = Matter.where(actived: true).order(code: :asc)
  end

  def getMatterOptions
    matters = Matter.where(actived: true).order(name: :asc)
    result = []
    matters.each do |matter|
      result << "#{matter.code} - #{matter.name}"
    end
    result
  end

  def show_matter
    @show = true
  end

end
