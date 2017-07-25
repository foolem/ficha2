class Ficha < ApplicationRecord
  belongs_to :user
  belongs_to :matter

  validates :user, presence: true
  validates :matter, presence: true

end
