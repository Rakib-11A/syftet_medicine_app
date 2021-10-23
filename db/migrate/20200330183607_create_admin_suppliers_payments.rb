class CreateAdminSuppliersPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_suppliers_payments do |t|
      t.integer :supplier_id
      t.integer :paid_by_id
      t.string :method
      t.integer :amount
      t.date :payment_date
      t.date :value_date
      t.string :cheque_number
      t.string :status
      t.boolean :confirmed
      t.string :paid_to
      t.integer :invoice_id
      t.boolean :is_group_payment, default: false
      t.float :commission

      t.timestamps null: false
    end
  end
end
