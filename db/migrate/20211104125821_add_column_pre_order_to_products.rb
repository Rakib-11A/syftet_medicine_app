# frozen_string_literal: true

class AddColumnPreOrderToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :pre_order, :boolean
  end
end
