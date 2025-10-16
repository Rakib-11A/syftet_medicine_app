# frozen_string_literal: true

class AddCouponIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :coupon_id, :integer
  end
end
