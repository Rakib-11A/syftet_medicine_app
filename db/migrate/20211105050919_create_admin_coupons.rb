# frozen_string_literal: true

class CreateAdminCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_coupons do |t|
      t.string :code
      t.string :name
      t.integer :discount
      t.integer :percentage
      t.date :expiration
      t.integer :maximun_limit

      t.timestamps
    end
  end
end
