class Ficha < ApplicationRecord
  belongs_to :user
  belongs_to :matter

  validates :user, presence: true
  validates :matter, presence: true

  validates :year, presence: true
  validates :semester, presence: true

  validates :status, presence: true

  #validates :program, presence: true

  #validates :general_objective, presence: true
  #validates :specific_objective, presence: true

  #validates :didactic_procedures, presence: true
  #validates :evaluation, presence: true

  #validates :basic_bibliography, presence: true
  #validates :bibliography, presence: true

end
