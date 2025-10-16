# frozen_string_literal: true

# == Schema Information
#
# Table name: stock_transfers
#
#  id                      :integer          not null, primary key
#  transfer_type           :string
#  reference               :string
#  source_location_id      :integer
#  destination_location_id :integer
#  number                  :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class StockTransfer < ApplicationRecord
  belongs_to :source_location, class_name: 'StockLocation', optional: true
  belongs_to :destination_location, class_name: 'StockLocation', optional: true
  has_many :stock_movements, as: :originator

  # def to_param
  #   number
  # end

  def source_movements
    find_stock_location_with_location_id(source_location_id)
  end

  def destination_movements
    find_stock_location_with_location_id(destination_location_id)
  end

  def transfer(source_location, destination_location, products)
    transaction do
      products.each_pair do |product, quantity|
        source_location&.unstock(product, quantity, self)
        destination_location.restock(product, quantity, self)
        self.number = "#{Date.today.strftime('%Y%m%d')}-#{id}"
        self.source_location = source_location
        self.destination_location = destination_location
        save!
      end
    end
  end

  def receive(destination_location, products)
    transfer(nil, destination_location, products)
  end

  private

  def find_stock_location_with_location_id(location_id)
    stock_movements.joins(:stock_item).where('stock_items.stock_location_id' => location_id)
  end
end
