class UniteMatter < ApplicationRecord
  has_many :matters

  def matter_codes
      matters.collect { |matter| matter.code }
  end

end
