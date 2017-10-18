class Unavailability < ApplicationRecord
  belongs_to :availability
  belongs_to :schedule, optional: true

  accepts_nested_attributes_for :schedule
end
