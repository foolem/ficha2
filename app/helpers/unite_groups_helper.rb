module UniteGroupsHelper
  def new_unite_group
      @new = true
  end

  def show_unite_group
      @show = true
  end

  def edit_unite_group
      @edit = true
  end


  def unit_groups(unite)
    result = ""

    unite.groups.length.times do |i|

      group = unite.groups[i-1]
      text = "<span>#{group.code_with_group_show}</span>"

      if i != (unite.groups.length) -(1)
        if i == (unite.groups.length) -(2)
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
