class Group < ApplicationRecord
  belongs_to :matter
  belongs_to :semester
  has_one :ficha

  def code_with_group
    "#{name} -  #{matter.code}"
  end

end
