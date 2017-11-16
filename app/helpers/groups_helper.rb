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

    if @unite_group.has_group?
        return @unite_group.groups.first.same_groups.select {|group| group.unite_group.blank? }
    end

    if !@unite_group.matter.has_unite?
      return Group.joins(:matter).where("
        matters.id = #{@unite_group.matter_id}
        and groups.unite_group_id IS NULL
        and groups.semester_id = #{@unite_group.semester_id}")
    end

    return Group.joins(:matter).where("
      matters.unite_matter_id = #{@unite_group.matter.unite_matter_id}
      and groups.unite_group_id IS NULL
      and groups.semester_id = #{@unite_group.semester_id}")
  end

end
