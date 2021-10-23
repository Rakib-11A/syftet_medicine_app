class Admin::Suppliers::InvoiceItem < ApplicationRecord
  belongs_to :product
  belongs_to :invoice, :class_name => 'Admin::Suppliers::Invoice'
  has_many :refund_items, class_name: 'Admin::Suppliers::RefundItem'

  scope :received, -> { where("received_quantity IS NOT NULL and received_quantity > 0") }

  after_save :update_product_expaire_date

  def update_product_expaire_date
    if self.expaire_date.present?
      product = Product.find(product_id)
      product.expires.create(date: expaire_date)
    end
  end

  def return_item_count
    refund_items.sum(:quantity)
  end

  def add_sale_quantity_total(variant, vat, quantity)
    self.product = variant
    self.sale_price = variant.cost_price + ((vat * variant.cost_price) / 100.0 )
    self.total = ((quantity.to_f) * variant.cost_price)
    self.cost_price = variant.cost_price
    self.issued_quantity = quantity
    self.vat = vat
    self.save!
  end

  def change_sale_price(sale_price)
    self.sale_price = sale_price
    self.vat = (((sale_price - self.cost_price) * 100.0) / cost_price)
    self.save!
  end

  def change_vat(vat)
    self.vat = vat
    self.sale_price += ((vat * self.cost_price) / 100.0)
    self.save!
  end

  def increase_receive_quantity(quantity)
    self.received_quantity += quantity
    self.total += (self.cost_price * quantity)
    self.save!
  end

  def decrease_receive_quantity(quantity)
    self.received_quantity = quantity
    self.total = (self.cost_price * quantity)
    self.save!
  end

  def change_cost_price(cost_price)
    self.cost_price = cost_price
    self.total = self.received_quantity * cost_price
    self.sale_price = cost_price + ((cost_price * self.vat) / 100.0)
    self.save!
  end
end
