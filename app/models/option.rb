class Option < ApplicationRecord
  has_many :groups
  has_many :wishes
  has_many :users, through: :wishes
  
  has_many :matters, through: :groups
  has_many :schedules, through: :groups

end
