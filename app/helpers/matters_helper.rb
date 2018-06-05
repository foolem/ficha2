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

  def matters_no_united
    matters = []
    m = Matter.all
    m.each do |ma|

      if ma.unite_matter.blank?
        matters.push ma
      else
        if ma.unite_matter.semester_id != Semester.current_semester.id
          matters.push ma
        end
      end
    end
    matters
  end

  def actived_matters
    Matter.where(actived: true)
  end

  def show_matter
    @show = true
  end

end
