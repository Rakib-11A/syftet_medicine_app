# frozen_string_literal: true

class AddCollectionPointToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :collection_point, :string
  end
end
