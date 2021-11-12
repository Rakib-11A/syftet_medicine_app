class AddCouponIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :coupon_id, :integer
    add_foreign_key :admin_coupons, :orders
  end
end
