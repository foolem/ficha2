class Option < ApplicationRecord
  belongs_to :semester
  has_many :groups
  has_many :wishes
  has_many :comments, through: :wishes, source: :option
  has_many :users, through: :wishes

  has_many :matters, through: :groups
  has_many :schedules, through: :groups

end
