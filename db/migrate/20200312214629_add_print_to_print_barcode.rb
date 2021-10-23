class AddPrintToPrintBarcode < ActiveRecord::Migration[5.2]
  def change
    add_reference :print_barcodes, :print, foreign_key: true
  end
end
