# frozen_string_literal: true

class AddNumberFieldToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :number, :string
  end
end
