class Matter < ApplicationRecord
  has_many :ficha
  has_many :groups

  belongs_to :unite_matter

  validates :name, presence: true
  validates :code, uniqueness: true, presence: true

  validates :kind, presence: true
  validates :modality, presence: true
  validates :nature, presence: true
  validates :menu, presence: true

  def code_with_name
    code + " - " + name
  end

end
