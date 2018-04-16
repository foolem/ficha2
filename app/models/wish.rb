class Wish < ApplicationRecord
  belongs_to :option
  belongs_to :user
  belongs_to :group, optional: true

end
