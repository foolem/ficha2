module UniteMattersHelper

  def new_unite_matter
      @new = true
  end

  def show_unite_matter
      @show = true
  end

  def edit_unite_matter
      @edit = true
  end


  def unit_matters(unite)
    result = ""

    unite.matters.length.times do |i|

      matter = unite.matters[i-1]
      text = "<span>#{matter.code}</span>"

      if i != (unite.matters.length) -(1)
        if i == (unite.matters.length) -(2)
          text << " e "
        else
          text << ", "
        end
      end

      result << text
    end
    result
  end

end
