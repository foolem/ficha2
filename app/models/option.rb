class Option < ApplicationRecord
  belongs_to :semester
  has_many :groups
  has_many :wishes
  has_many :users, through: :wishes

  has_many :matters, through: :groups
  has_many :schedules, through: :groups

  def self.hard_reset
    Wish.where(semester_id: Semester.current_semester.id).all.delete_all
    Group.where(semester_id: Semester.current_semester.id).all.each do |grp|
      grp.option = nil
      grp.save
    end
    Option.where(semester_id: Semester.current_semester.id).all.each do |opt|
      opt.groups.destroy_all
      opt.destroy
    end
    #Option.where(semester_id: Semester.current_semester.id).all.destroy_all

  end

end
