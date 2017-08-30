class User < ApplicationRecord

  enum role: [:teacher, :appraiser, :admin, :secretary]

  has_many :ficha
  has_many :wishes

  validates :name, presence: true
  validates :role, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def reset
    email = "ficha2.mat@gmail.com"
    super.send_reset_password_instructions
  end
end
