# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :name
      t.text :description
      t.string :origin
      t.string :slug
      t.string :meta_title
      t.text :meta_desc
      t.string :keywords
      t.references :brand
      t.boolean :is_featured, default: false, null: false
      t.boolean :is_active, default: true, null: false
      t.datetime :deleted_at
      t.integer :product_id
      t.decimal :sale_price, default: 0.0, null: false, precision: 22, scale: 6
      t.decimal :cost_price, default: 0.0, null: false, precision: 22, scale: 6
      t.decimal :whole_sale, default: 0.0, null: false, precision: 22, scale: 6
      t.string :color_name
      t.string :color
      t.string :size
      t.string :weight
      t.string :width
      t.string :height
      t.string :depth
      t.boolean :discountable, default: false
      t.boolean :is_amount, default: false
      t.decimal :discount, default: 0.0, null: false, precision: 22, scale: 6
      t.decimal :reward_point, default: 0.0, null: false, precision: 22, scale: 6

      t.timestamps
    end
  end
end
