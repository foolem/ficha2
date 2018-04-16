class Contact
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :message, :email

  validates :name,
            :length => {:in => 2..50}

  validates :email,
            :format => {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/}

  validates :message,
            :length => {:in => 10..750}

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
