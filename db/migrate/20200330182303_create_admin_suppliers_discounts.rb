class CreateAdminSuppliersDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_suppliers_discounts do |t|
      t.integer :amount
      t.date :date
      t.string :discount_by
      t.string :discount_reason
      t.string :invoice_no
      t.integer :invoice_id
      t.integer :supplier_id, index: true

      t.timestamps null: false
    end
  end
end
