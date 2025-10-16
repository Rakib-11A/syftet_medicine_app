# frozen_string_literal: true

class AddMinStockToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :min_stock, :integer, default: 0
  end
end
