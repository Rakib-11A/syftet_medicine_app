class AddPreOrderToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :pre_order, :boolean
    add_foreign_key :products, :orders
  end
end
