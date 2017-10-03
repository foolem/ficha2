class Option < ApplicationRecord
  belongs_to :semester
  has_many :groups
  has_many :wishes
  has_many :users, through: :wishes

  has_many :matters, through: :groups
  has_many :schedules, through: :groups

  def self.hard_reset
    Wish.delete_all
    Group.all.each do |grp|
      grp.option = nil
      grp.save
    end
    Option.destroy_all
  end

end
