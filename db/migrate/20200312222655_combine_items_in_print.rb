class CombineItemsInPrint < ActiveRecord::Migration[5.2]
  def up
# replace multiple items for a single product in a cart with a
# single item
    Print.all.each do |print|
# count the number of each product in the cart
      sums = print.print_barcodes.group(:product_id).sum(:quantity)
      sums.each do |product_id, quantity|
        if quantity > 1
# remove individual product
          print.print_barcodes.where(product_id: product_id).delete_all
# replace with a single product
          product = print.print_barcodes.build(product_id: product_id)
          product.quantity = quantity
          product.save!
        end
      end
    end
  end

  def down
# split items with quantity>1 into multiple items
    PrintBarcode.where("quantity>1").each do |barcode|
# add individual items
      barcode.quantity.times do
        PrintBarcode.create(
            print_id: barcode.print_id,
            product_id: barcode.product_id,
            quantity: 1,
            user_id: barcode.user_id
        )
      end
# remove original item
      barcode.destroy
    end
  end
end
