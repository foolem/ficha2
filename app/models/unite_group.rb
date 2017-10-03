class UniteGroup < ApplicationRecord
  has_many :groups
  belongs_to :matter
  belongs_to :semester

  def has_group?
    !groups.blank?
  end

  def group_names
    groups.collect { |group| group.code_with_group }
  end

end
