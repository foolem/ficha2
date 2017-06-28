class User < ApplicationRecord

  enum role: [:teacher, :appraiser, :admin, :secretary]

  has_many :ficha

  validates :name, presence: true
  validates :role, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
