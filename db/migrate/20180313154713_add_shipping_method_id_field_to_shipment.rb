class AddShippingMethodIdFieldToShipment < ActiveRecord::Migration[5.2]
  def change
    add_column :shipments, :shipping_method_id, :integer
  end
end
