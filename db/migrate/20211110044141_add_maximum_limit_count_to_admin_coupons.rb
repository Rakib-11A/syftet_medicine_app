class AddMaximumLimitCountToAdminCoupons < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_coupons, :maximum_limit_count, :integer, default: 0
  end
end
