class CreateAdminSuppliersRefundItems < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_suppliers_refund_items do |t|
      t.integer :refund_id
      t.integer :invoice_item_id
      t.float :amount
      t.integer :quantity
      t.float :cost_price
      t.references :product, foreign_key: true

      t.timestamps null: false
    end
  end
end
