# frozen_string_literal: true

class AddShipAddressToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ship_address_id, :integer
  end
end
