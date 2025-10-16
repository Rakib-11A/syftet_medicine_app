# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_suppliers_invoice_items
#
#  id                :integer          not null, primary key
#  note              :text
#  issued_quantity   :integer
#  received_quantity :integer
#  cost_price        :float
#  sale_price        :float
#  vat               :float
#  total             :float
#  expaire_date      :date
#  invoice_id        :integer
#  product_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_admin_suppliers_invoice_items_on_product_id  (product_id)
#

module Admin
  module Suppliers
    class InvoiceItem < ApplicationRecord
      belongs_to :product
      belongs_to :invoice, class_name: 'Admin::Suppliers::Invoice'
      has_many :refund_items, class_name: 'Admin::Suppliers::RefundItem'

      scope :received, -> { where('received_quantity IS NOT NULL and received_quantity > 0') }

      after_save :update_product_expaire_date

      def update_product_expaire_date
        return unless expaire_date.present?

        product = Product.find(product_id)
        product.expires.create(date: expaire_date)
      end

      def return_item_count
        refund_items.sum(:quantity)
      end

      def add_sale_quantity_total(variant, vat, quantity)
        self.product = variant
        self.sale_price = variant.cost_price + ((vat * variant.cost_price) / 100.0)
        self.total = (quantity.to_f * variant.cost_price)
        self.cost_price = variant.cost_price
        self.issued_quantity = quantity
        self.vat = vat
        save!
      end

      def change_sale_price(sale_price)
        self.sale_price = sale_price
        self.vat = (((sale_price - cost_price) * 100.0) / cost_price)
        save!
      end

      def change_vat(vat)
        self.vat = vat
        self.sale_price += ((vat * cost_price) / 100.0)
        save!
      end

      def increase_receive_quantity(quantity)
        self.received_quantity += quantity
        self.total += (cost_price * quantity)
        save!
      end

      def decrease_receive_quantity(quantity)
        self.received_quantity = quantity
        self.total = (cost_price * quantity)
        save!
      end

      def change_cost_price(cost_price)
        self.cost_price = cost_price
        self.total = self.received_quantity * cost_price
        self.sale_price = cost_price + ((cost_price * vat) / 100.0)
        save!
      end
    end
  end
end
