class UniteMatter < ApplicationRecord
  has_many :matters
  belongs_to :semester
  
  def matter_codes
      matters.collect { |matter| matter.code }
  end

end
