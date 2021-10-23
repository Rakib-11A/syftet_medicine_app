class Admin::Suppliers::Discount < ApplicationRecord
  validates :supplier_id, :amount, :date, presence: true

  belongs_to :supplier, class_name: 'User'
  belongs_to :invoice, class_name: 'Admin::Suppliers::Invoice'
end
