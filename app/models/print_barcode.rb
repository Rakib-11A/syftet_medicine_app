# == Schema Information
#
# Table name: print_barcodes
#
#  id         :integer          not null, primary key
#  quantity   :integer
#  user_id    :integer
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  print_id   :integer
#
# Indexes
#
#  index_print_barcodes_on_print_id    (print_id)
#  index_print_barcodes_on_product_id  (product_id)
#  index_print_barcodes_on_user_id     (user_id)
#

class PrintBarcode < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :print


end
