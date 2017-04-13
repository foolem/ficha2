class Teacher < ApplicationRecord
  #belongs_to :matter
  has_many :ficha

  validates :name, presence: true
  validates :email, presence: true

end
