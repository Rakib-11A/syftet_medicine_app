# == Schema Information
#
# Table name: prints
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Print < ApplicationRecord
  has_many :print_barcodes, dependent: :destroy


  def add_product(product,quantity)
    current_print_barcodes = print_barcodes.find_by(product_id: product.id)
    if current_print_barcodes
      current_print_barcodes.quantity += quantity.to_i
    else
      current_print_barcodes = print_barcodes.build(product_id: product.id, quantity: quantity)
    end
    current_print_barcodes
  end
end
