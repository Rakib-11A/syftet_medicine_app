# frozen_string_literal: true

class AddColumnTrackInventoryToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :track_inventory, :boolean, default: true
  end
end
