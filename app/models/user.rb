class User < ApplicationRecord

  enum role: [:teacher, :appraiser, :admin, :secretary]

  has_many :ficha

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
