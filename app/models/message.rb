class Message < ApplicationRecord
  belongs_to :user
  belongs_to :ficha, optional: true
end
