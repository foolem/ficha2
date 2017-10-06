class Unavailability < ApplicationRecord
  belongs_to :availability
  belongs_to :schedule
end
