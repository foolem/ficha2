class Availability < ApplicationRecord
  belongs_to :semester
  belongs_to :user
  has_many :unavailabilities

  PREFERENCES = ["Aulas geminadas", "Aulas em mesmo dia", "Sextas livres", "Segundas livres", "Aulas em mesmo periodo"]

  enum preference_first: PREFERENCES
  enum preference_second: PREFERENCES
  enum preference_third: PREFERENCES
end
