class Availability < ApplicationRecord
  belongs_to :semester
  belongs_to :user
  has_many :unavailabilities

  def self.find_by_user(user)
    Availability.where(user_id: user.id, semester_id: Semester.current_semester).first
  end
  
end
