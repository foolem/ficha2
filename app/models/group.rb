class Group < ApplicationRecord
  belongs_to :matter
  belongs_to :semester
  belongs_to :course, optional: true

  has_one :ficha
  has_and_belongs_to_many :schedules
  belongs_to :option, optional: true
  belongs_to :unite_group, optional: true

  def code_with_group
    "#{name} - #{matter.code}"
  end

  def group_with_code
    "#{matter.code}-#{name}"
  end

  def code_with_group_show
    "#{matter.code} - #{name}"
  end

  def code_with_group_and_name
    "#{name} -  #{matter.code} - #{matter.name}"
  end

  def name_with_course
    "#{name} - #{course.name}"
  end

  def code_name_and_course
    "#{matter.code} #{name_with_course}"
  end

  def has_unite?
    !unite_group.blank?
  end

  def has_ficha?
    !ficha.blank?
  end

  def same_groups
    return [self] if schedules.blank?

    same_matter_groups.reject { |grp| self.schedules.pluck(:id) != grp.schedules.pluck(:id) }
  end

  def same_matter_groups
    return matter.groups.where(semester_id: self.semester_id) if matter.unite_matter.blank?

    matter.unite_matter.matters.map do |matter|
      matter.groups.where(semester_id: self.semester_id)
    end.flatten
  end
end
