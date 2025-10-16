# frozen_string_literal: true

class CreateRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :refunds do |t|
      t.integer :payment_id
      t.numeric :amount
      t.string :reason
      t.timestamps
    end
  end
end
