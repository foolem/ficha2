class Schedule < ApplicationRecord

  enum day: [:sunday, :monday, :thursday, :wednesday, :tuesday, :friday, :saturday]

  has_and_belongs_to_many :groups

  def self.days
    [:sunday, :monday, :thursday, :wednesday, :tuesday, :friday, :saturday]
  end


  def parse_to_time
    self.begin = self.begin.to_time
    self.duration = self.duration.to_time
  end

end
