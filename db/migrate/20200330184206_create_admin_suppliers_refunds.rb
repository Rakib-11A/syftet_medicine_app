class CreateAdminSuppliersRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_suppliers_refunds do |t|
      t.integer :amount
      t.date :date
      t.string :invoice_no
      t.boolean :is_order, default: false
      t.string :refund_by
      t.string :refund_reason
      t.integer :employee_id
      t.integer :invoice_id
      t.integer :supplier_id, index: true

      t.timestamps null: false
    end
  end
end
