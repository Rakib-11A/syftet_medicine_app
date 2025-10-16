# frozen_string_literal: true

class AddTaxTotalFieldToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :tax_total, :decimal, default: 0
  end
end
