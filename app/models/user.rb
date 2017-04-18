class User < ApplicationRecord

  enum role: [:teacher, :appraiser, :admin]

  has_many :ficha
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
