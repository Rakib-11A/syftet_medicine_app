class AddColumnBarcodeToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :barcode, :string
    add_index :products, :barcode, unique: true
  end
end
