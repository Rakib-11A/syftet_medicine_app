# frozen_string_literal: true

class AddColumnSupplierIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :supplier_id, :integer
  end
end
