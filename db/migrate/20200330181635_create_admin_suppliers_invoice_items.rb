class CreateAdminSuppliersInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_suppliers_invoice_items do |t|
      t.text :note
      t.integer :issued_quantity
      t.integer :received_quantity
      t.float :cost_price
      t.float :sale_price
      t.float :vat
      t.float :total
      t.date :expaire_date
      t.integer :invoice_id
      t.references :product, foreign_key: true

      t.timestamps null: false
    end
  end
end
