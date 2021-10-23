class CreateAdminSuppliersTextMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_suppliers_text_messages do |t|
      t.integer :supplier_id
      t.integer :employee_id
      t.text :content
      t.string :direction
      t.boolean :read

      t.timestamps null: false
    end
  end
end
