class Matter < ApplicationRecord
  has_many :ficha

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
