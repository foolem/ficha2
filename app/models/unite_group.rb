class UniteGroup < ApplicationRecord
  has_many :groups
  belongs_to :unite_matter, optional: true
end
