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
