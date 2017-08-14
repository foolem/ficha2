class Ficha < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum status: [:editing, :sent, :ready, :reproved]

  validates :group, presence: true

  def semester_with_year
    "#{semester}#{year}"
  end

end
