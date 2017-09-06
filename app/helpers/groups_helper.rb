module GroupsHelper
  def groups_order

    groups = []
    Group.all.each do |group|
      if group.ficha == nil
        groups << group
      end
    end
    groups
  end

  def new_group
      @new = true
  end

  def groups_no_united
    Group.where(unite_group: nil)
  end

end
