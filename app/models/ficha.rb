class Ficha < ApplicationRecord
  belongs_to :user
  belongs_to :matter

  enum status: [:editing, :sent, :ready, :reproved]

  validates :user, presence: true
  validates :matter, presence: true
  validates :team, presence: true

  def semester_with_year
    "#{semester}#{year}"
  end

end
