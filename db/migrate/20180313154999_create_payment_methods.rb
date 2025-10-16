# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods do |t|
      t.string :type
      t.string :name
      t.text :description
      t.boolean :active
      t.text :preferences

      t.timestamps
    end
  end
end
