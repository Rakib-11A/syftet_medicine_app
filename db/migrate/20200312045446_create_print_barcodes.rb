class CreatePrintBarcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :print_barcodes do |t|
      t.integer :quantity
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
