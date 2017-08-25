class Option < ApplicationRecord
  has_many :groups
  has_and_belongs_to_many :users

  has_many :matters, through: :groups
  has_many :schedules, through: :groups

end
