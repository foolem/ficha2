class Role < ApplicationRecord

  ROLES = {
    admin: "administrador",
    teacher: "professor",
    appraiser: "avaliador",
    secretary: "secretário",
    counselor: "conselheiro"}

  def self.permited_roles
    ROLES.map do |key, value|
      key.to_s
    end
  end

  def self.role_by_index(index)
    permited_roles[index]
  end

  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  validates :name, inclusion: { in: permited_roles }

  scopify
end
