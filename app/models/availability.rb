class Availability < ApplicationRecord
  belongs_to :semester
  belongs_to :user
  has_many :unavailabilities

end
