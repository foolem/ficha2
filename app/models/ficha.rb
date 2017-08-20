class Ficha < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :messages, dependent: :destroy

  #accepts_nested_attributes_for :messages, allow_destroy: true, :reject_if proc { |att| att['message'].blank? }
  accepts_nested_attributes_for :messages, reject_if: :all_blank, allow_destroy: true
  #accepts_nested_attributes_for :messages, allow_destroy: true, :reject_if :all_blank

  enum status: [:editing, :sent, :ready, :reproved]

  validates :group, presence: true

  def semester_with_year
    "#{semester}#{year}"
  end

end
