# frozen_string_literal: true

class CreateReturnItems < ActiveRecord::Migration[5.2]
  def change
    create_table :return_items do |t|
      t.integer :customer_return_id
      t.integer :line_item_id
      t.boolean :resellable

      t.timestamps
    end
  end
end
