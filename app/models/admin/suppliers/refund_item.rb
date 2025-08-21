# == Schema Information
#
# Table name: admin_suppliers_refund_items
#
#  id              :integer          not null, primary key
#  refund_id       :integer
#  invoice_item_id :integer
#  amount          :float
#  quantity        :integer
#  cost_price      :float
#  product_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admin_suppliers_refund_items_on_product_id  (product_id)
#

class Admin::Suppliers::RefundItem < ApplicationRecord
  belongs_to :product
  belongs_to :refund, class_name: 'Admin::Suppliers::Refund'
  belongs_to :invoice_item, class_name: 'Admin::Suppliers::InvoiceItem'
  has_one :products_stock, class_name: 'StockItem', as: :stockable, dependent: :destroy
  # after_save :update_stock

  private

  def update_stock
    create_products_stock(product_id: product.present? ? product.id : invoice_item.product_id, quantity: (quantity * -1), stock_location_id: refund.invoice.present? ? refund.invoice.stock_location_id : '') if invoice_item.present? || product.present?
  end
end
