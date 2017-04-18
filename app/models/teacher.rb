class Teacher < ApplicationRecord
  #belongs_to :matter

  validates :name, presence: true
  validates :email, presence: true

end
