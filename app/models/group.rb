class Group < ApplicationRecord
  belongs_to :matter
  belongs_to :semester
end
