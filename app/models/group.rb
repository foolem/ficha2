class Group < ApplicationRecord
  belongs_to :matter
  belongs_to :semester
  belongs_to :user
  has_one :ficha
end
