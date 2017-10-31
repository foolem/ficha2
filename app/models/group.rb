class Group < ApplicationRecord
  belongs_to :matter
  belongs_to :semester
  belongs_to :course, optional: true

  has_one :ficha
  has_and_belongs_to_many :schedules
  belongs_to :option, optional: true
  belongs_to :unite_group, optional: true

  def code_with_group
    "#{name} -  #{matter.code}"
  end

  def code_with_group_show
    "#{matter.code} - #{name}"
  end

  def code_with_group_and_name
    "#{name} -  #{matter.code} - #{matter.name}"
  end

  def has_unite?
    !unite_group.blank?
  end

  def has_ficha?
    !ficha.blank?
  end

  def same_groups
    if schedules.length == 0
      return [self]
    end


    result = []
    groups = []

    if !matter.unite_matter.blank?
      matter.unite_matter.matters.each do |matter|
        matter.groups.each do |grp|
          if grp.semester = semester
            groups << grp
          end
        end
      end
    else
      groups = matter.groups
    end

    groups.each do |grp|
      if schedules == grp.schedules
        result << grp
      end
    end

    result
  end

end
