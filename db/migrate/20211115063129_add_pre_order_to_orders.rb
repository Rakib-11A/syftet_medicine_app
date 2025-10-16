# frozen_string_literal: true

class AddPreOrderToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :pre_order, :boolean
  end
end
