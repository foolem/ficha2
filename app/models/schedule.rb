class Schedule < ApplicationRecord

  enum day: [:sunday, :monday, :thursday, :wednesday, :tuesday, :friday, :saturday]

  has_and_belongs_to_many :groups

end
