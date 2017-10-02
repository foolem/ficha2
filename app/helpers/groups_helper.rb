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
    Group.joins(:matter).where("matters.unite_matter_id = #{@unite_group.unite_matter.id} and groups.unite_group_id IS NULL")
  end

end
