# frozen_string_literal: true

class AddColumnBackdoorToShippingMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :shipping_methods, :backdoor_only, :boolean, default: false
  end
end
