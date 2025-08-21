# == Schema Information
#
# Table name: admin_suppliers_discounts
#
#  id              :integer          not null, primary key
#  amount          :integer
#  date            :date
#  discount_by     :string
#  discount_reason :string
#  invoice_no      :string
#  invoice_id      :integer
#  supplier_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admin_suppliers_discounts_on_supplier_id  (supplier_id)
#

class Admin::Suppliers::Discount < ApplicationRecord
  validates :supplier_id, :amount, :date, presence: true

  belongs_to :supplier, class_name: 'User'
  belongs_to :invoice, class_name: 'Admin::Suppliers::Invoice'
end
