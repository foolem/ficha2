class Matter < ApplicationRecord
  has_many :ficha
  has_many :groups

  belongs_to :unite_matter, optional: true

  validates :name, presence: true
  validates :code, uniqueness: true, presence: true

  validates :kind, presence: true
  validates :modality, presence: true
  validates :nature, presence: true
  validates :menu, presence: true

  def code_with_name
    code + " - " + name
  end

  def name_with_code
    name + ": " + code
  end

  def has_unite?
    !unite_matter.blank?
  end

  def get_groups(semester)
    if !has_unite?
      return Group.where(matter_id: id, semester_id: semester)
    end
    Group.joins(:matter).where("matters.unite_matter_id = #{unite_matter_id} and semester_id = #{semester}")
  end


end
