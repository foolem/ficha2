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
end
