# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  firstname  :string
#  lastname   :string
#  address    :string
#  city       :string
#  zipcode    :string
#  phone      :string
#  state      :string
#  company    :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ApplicationRecord

  with_options presence: true do
    validates :firstname, :lastname, :address, :city, :country
    validates :zipcode
    validates :phone
  end

  alias_attribute :first_name, :firstname
  alias_attribute :last_name, :lastname

  def self.build_default(user)
    if user.present? && user.ship_address.present?
      user.ship_address.clone
    else
      new
    end
  end

  def full_name
    "#{firstname} #{lastname}".strip
  end

  def to_s
    "#{full_name}: #{address}"
  end

  def clone
    self.class.new(self.attributes.except('id', 'updated_at', 'created_at'))
  end

  def not_provided?
    firstname == 'N/A' && lastname == 'N/A' && address == 'N/A' && city == 'N/A' && zipcode == 'N/A' && phone == 'N/A' && state  == 'N/A' && company == 'N/A' && country  == 'N/A'
  end
end
