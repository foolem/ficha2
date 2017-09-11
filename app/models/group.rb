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

end
