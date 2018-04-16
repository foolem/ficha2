class Availability < ApplicationRecord
  belongs_to :semester
  belongs_to :user
  has_many :unavailabilities

  def self.find_by_user(user)
    Availability.where(user_id: user.id, semester_id: Semester.current_semester).first
  end

  def self.find_by_semester(user, semester)
    Availability.where(user_id: user.id, semester_id: semester).first
  end

end
